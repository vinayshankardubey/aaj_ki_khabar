import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TweetWebView extends StatefulWidget {
  final String? tweetUrl;

  final double? aspectRatio;

  TweetWebView({this.tweetUrl, this.aspectRatio});

  @override
  _TweetWebViewState createState() => new _TweetWebViewState();
}

class _TweetWebViewState extends State<TweetWebView> {
  late final WebViewController wbController;
  String? _postHTML;
  double _height = 450;
  String? lastUrl;

  @override
  void initState() {
    super.initState();

    String extractLastUrl(String input) {
      final urlPattern = RegExp(
        r'(https?://[^\s]+)',
        caseSensitive: false,
      );
      final matches = urlPattern.allMatches(input);

      if (matches.isNotEmpty) {
        return matches.last.group(0) ?? '';
      }
      return '';
    }

    _postHTML = widget.tweetUrl!;
    lastUrl = _postHTML!.contains("twitter") ? 'https://platform.twitter.com/widgets.js' : 'https://www.instagram.com/embed.js';

    if (widget.tweetUrl != null && widget.tweetUrl!.isNotEmpty) {
      lastUrl = extractLastUrl(widget.tweetUrl!);
      print("Last Url is ==> $lastUrl");

      wbController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..addJavaScriptChannel('PageHeight', onMessageReceived: (JavaScriptMessage message) {
          try {
            _setHeight(double.parse(message.message));
          } catch (e) {
            print("Error parsing height: $e");
          }
        })
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (String url) {
              final color = colorToHtmlRGBA(getBackgroundColor(context));
              wbController.runJavaScript('document.body.style= "background-color: $color"');
              wbController.runJavaScript('setTimeout(() => sendHeight(), 0)');
              print("Page finished loading: $url");
            },
            onHttpError: (HttpResponseError error) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) async {
              if (request.isMainFrame) {
                if (request.url.startsWith("http") || request.url.startsWith("https")) {
                  if (await canLaunchUrl(Uri.parse(lastUrl!))) {
                    await launchUrl(Uri.parse(lastUrl!));
                    return NavigationDecision.prevent;
                  }
                }
              }
              return NavigationDecision.navigate;
            },
          ),
        );

      if (lastUrl != null) {
        wbController.loadRequest(Uri.parse(lastUrl!));
      } else {
        print("Invalid or missing lastUrl.");
      }
    } else {
      print("Invalid tweet URL: ${widget.tweetUrl}");
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wv = WebViewWidget(controller: wbController);

    // WebView(
    //   initialUrl: Uri.dataFromString(getHtmlBody(), mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString(),
    //   javascriptMode: JavascriptMode.unrestricted,
    //   javascriptChannels: <JavascriptChannel>[_getHeightJavascriptChannel()].toSet(),
    //   initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
    //   gestureNavigationEnabled: true,
    //   onWebViewCreated: (wbc) {
    //     wbController = wbc;
    //   },
    //   onPageFinished: (str) {
    //     final color = colorToHtmlRGBA(getBackgroundColor(context));
    //     wbController.runJavascript('document.body.style= "background-color: $color"');
    //     wbController.runJavascript('setTimeout(() => sendHeight(), 0)');
    //   },
    //   navigationDelegate: (navigation) async {
    //     final url = navigation.url;
    //     if (navigation.isForMainFrame && await launchUrl(Uri.parse(url))) {
    //       await launchUrl(Uri.parse(url));
    //       return NavigationDecision.prevent;
    //     }
    //     return NavigationDecision.navigate;
    //   },
    // );

    final ar = widget.aspectRatio;
    return (ar != null)
        ? ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height / 1.5,
              maxWidth: context.width(),
            ),
            child: AspectRatio(aspectRatio: ar, child: wv),
          )
        : SizedBox(height: _height, child: wv, width: context.width());
  }

  void _setHeight(double height) {
    setState(() {
      _height = height;
    });
  }

  String colorToHtmlRGBA(Color c) {
    return 'rgba(${c.red},${c.green},${c.blue},${c.alpha / 255})';
  }

  Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  // String getHtmlBody() => """
  //     <html>
  //       <head>
  //         <meta name="viewport" content="width=device-width, initial-scale=1">
  //         <style>
  //           *{box-sizing: border-box;margin:0px; padding:0px;}
  //             #widget {
  //                       display: flex;
  //                       justify-content: center;
  //                       margin: 0 auto;
  //                       max-width:100%;
  //                   }
  //         </style>
  //       </head>
  //       <body>
  //         <div id="widget">$_postHTML $htmlScript</div>
  //         $dynamicHeightScriptSetup
  //         $dynamicHeightScriptCheck
  //       </body>
  //     </html>
  //   """;
  //
  // static const String dynamicHeightScriptSetup = """
  //   <script type="text/javascript">
  //     const widget = document.getElementById('widget');
  //     const sendHeight = () => PageHeight.postMessage(widget.clientHeight);
  //   </script>
  // """;
  //
  // static const String dynamicHeightScriptCheck = """
  //   <script type="text/javascript">
  //     const onWidgetResize = (widgets) => sendHeight();
  //     const resize_ob = new ResizeObserver(onWidgetResize);
  //     resize_ob.observe(widget);
  //   </script>
  // """;
  //
  // String get htmlScript => """
  //   <script type="text/javascript" src="$htmlScriptUrl"></script>
  // """;
  //
  // String get htmlScriptUrl => _postHTML!.contains("twitter") ? 'https://platform.twitter.com/widgets.js' : 'https://www.instagram.com/embed.js';
}
