import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../components/PdfViewWidget.dart';
import '../components/VimeoEmbedWidget.dart';
import '../components/YouTubeEmbedWidget.dart';
import '../../../utils/extension.dart';
import 'package:nb_utils/nb_utils.dart';
import 'AppWidgets.dart';
import 'TweetWidget.dart';

class HtmlWidget extends StatelessWidget {
  final String? postContent;
  final Color? color;

  HtmlWidget({this.postContent, this.color});

  @override
  Widget build(BuildContext context) {
    return Html(
      data: postContent!,
      onLinkTap: (url, attributes, element) async {
        if (url != null) {
          if (url.split('/').last.contains('.pdf')) {
            PdfViewWidget(pdfUrl: url).launch(context);
          } else {
            launchUrls(url, forceWebView: false);
          }
        }
      },
      style: {
        "table": Style(backgroundColor: color ?? transparentColor),
        "tr": Style(border: const Border(bottom: BorderSide(color: Colors.black45))),
        "th": Style(padding: HtmlPaddings.all(6), backgroundColor: Colors.black45.withOpacity(0.5)),
        "td": Style(padding: HtmlPaddings.all(6), alignment: Alignment.center),
        'embed': Style(
          color: color ?? transparentColor,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble()),
        ),
        'strong': Style(
          color: color ?? textPrimaryColorGlobal,
          fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble()),
        ),
        'a': Style(
          color: color ?? Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble()),
        ),
        'body': Style(
          color: color ?? textPrimaryColorGlobal,
          fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble()),
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
        ),
      },
      extensions: [
        TagExtension(
          tagsToExtend: {"iframe"},
          builder: (extensionContext) {
            final src = extensionContext.attributes['src'];
            if (src != null && src.contains('youtube.com')) {
              return YouTubeEmbedWidget(src.toYouTubeId());
            }
            if (src != null && src.contains('vimeo.com')) {
              return VimeoEmbedWidget(src.split('/').last);
            }
            return Container();
          },
        ),
        TagExtension(
          tagsToExtend: {"blockquote"},
          builder: (extensionContext) {
            return TweetWebView(tweetUrl: extensionContext.innerHtml);
          },
        ),
        TagExtension(
          tagsToExtend: {"img"},
          builder: (extensionContext) {
            String imgUrl = extensionContext.attributes['src'] ?? "";
            if (imgUrl.isEmpty) {
              imgUrl = extensionContext.attributes['data-src'] ?? "";
            }
            if (imgUrl.isNotEmpty) {
              return InkWell(
                onTap: () {
                  openPhotoViewer(context, NetworkImage(imgUrl));
                },
                child: cachedImage(imgUrl, width: context.width(), fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
              );
            }
            return Container();
          },
        ),
      ],
    );
  }
}
