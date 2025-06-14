// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class AudioPostWidget extends StatefulWidget {
//   static String tag = '/AudioPostWidget';
//   final String postString;
//   final double? aspectRatio;
//
//   AudioPostWidget({required this.postString, this.aspectRatio = 16 / 9});
//
//   @override
//   AudioPostWidgetState createState() => AudioPostWidgetState();
// }
//
// class AudioPostWidgetState extends State<AudioPostWidget> {
//   late final WebViewController wbController;
//   double _height = 300;
//   @override
//   void initState() {
//     super.initState();
//     init();
//   }
//   Future<void> init() async {
//     wbController = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageFinished: (String url) {},
//           onHttpError: (HttpResponseError error) {},
//           onWebResourceError: (WebResourceError error) {},
//           onNavigationRequest: (NavigationRequest request) {
//             if (request.url.startsWith(widget.postString!)) {
//               return NavigationDecision.prevent;
//             }
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse('https://flutter.dev'));
//
//     // ..loadRequest(Uri.parse(widget.postString!));
//   }
//
//     @override
//   void setState(fn) {
//     if (mounted) super.setState(fn);
//   }
//
//   @override
//   void dispose() {
//     // wbController.runJavascript(playAudioPost);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final wv = WebViewWidget(controller: wbController);
//
//     // WebView(
//     //   gestureNavigationEnabled: true,
//     //   initialUrl: Uri.dataFromString(getAudioHtml(), mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString(),
//     //   javascriptMode: JavascriptMode.unrestricted,
//     //   javascriptChannels: <JavascriptChannel>[_getHeightJavascriptChannel()].toSet(),
//     //   initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.require_user_action_for_all_media_types,
//     //   onWebViewCreated: (wbc) {
//     //     wbController = wbc;
//     //   },
//     //   onPageFinished: (str) {
//     //     final color = colorToHtmlRGBA(Theme.of(context).scaffoldBackgroundColor);
//     //
//     //     wbController.runJavascript('document.body.style= "background-color: $color"');
//     //     wbController.runJavascript('setTimeout(() => sendHeight(), 0)');
//     //   },
//     //   allowsInlineMediaPlayback: true,
//     // );
//     // final ar = widget.aspectRatio;
//     return Container(height: _height, child: wv, width: context.width(),alignment: Alignment.center,);
//     // return (ar != null)
//     //     ? ConstrainedBox(
//     //         constraints: BoxConstraints(
//     //           maxHeight: context.height() / 1,
//     //           maxWidth: context.width(),
//     //         ),
//     //         child: AspectRatio(aspectRatio: ar, child: wv),
//     //       )
//     //     : SizedBox(height: _height, child: wv, width: context.width());
//   }
//
//   // JavascriptChannel _getHeightJavascriptChannel() {
//   //   return JavascriptChannel(
//   //       name: 'PageHeight',
//   //       onMessageReceived: (JavascriptMessage message) {
//   //         _setHeight(double.parse(message.message));
//   //       });
//   // }
//
//   void _setHeight(double height) {
//     setState(() {
//       _height = height;
//     });
//   }
//
//   String colorToHtmlRGBA(Color c) {
//     return 'rgba(${c.red},${c.green},${c.blue},${c.alpha / 255})';
//   }
//
//   String getAudioHtml() => """
//   <html>
//   <style>
//     .play-button{
//       background-color: #cc1c2c;
//       border: none;
//       color: white;
//       padding: 16px;
//       text-align: center;
//       text-decoration: none;
//       display: inline-block;
//       font-size: 16px;
//       cursor: pointer;
//       border-radius: 16px;
//     }
//   </style>
//     <body>
//       <div id="audio-post">
//         ${widget.postString};
//         $dynamicHeightScriptSetup
//         $dynamicHeightScriptCheck
//       </div>
//       <br>
//         <div class='play-button' onclick="playAudio()">Play Audio</div>
//
//       <script>
//         var audio = document.getElementById("audio-post");
//
//         function playAudio(){
//           audio.play();
//         }
//
//         function pauseAudio(){
//           audio.pause();
//         }
//     }
//       </script>
//     </body>
//   </html>
//   """;
//
//   String get playAudioPost => "playAudio()";
//
//   static const String dynamicHeightScriptSetup = """
//     <script type="text/javascript">
//       const widget = document.getElementById('audio-post');
//       const sendHeight = () => PageHeight.postMessage(widget.clientHeight);
//     </script>
//   """;
//
//   static const String dynamicHeightScriptCheck = """
//     <script type="text/javascript">
//       const onWidgetResize = (widgets) => sendHeight();
//       const resize_ob = new ResizeObserver(onWidgetResize);
//       resize_ob.observe(widget);
//     </script>
//   """;
// }
