import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../utils/extension.dart';
import 'package:nb_utils/nb_utils.dart';

class YouTubeEmbedWidget extends StatefulWidget {
  final String videoId;
  final bool? fullIFrame;

  YouTubeEmbedWidget(this.videoId, {this.fullIFrame = false});

  @override
  State<YouTubeEmbedWidget> createState() => _YouTubeEmbedWidgetState();
}

class _YouTubeEmbedWidgetState extends State<YouTubeEmbedWidget> {
  String? path;

  @override
  void initState() {
    super.initState();
    path = widget.fullIFrame ?? false
        ? 'https://www.youtube.com/embed/${widget.videoId}'
        : 'https://www.youtube.com/embed/${widget.videoId}?autoplay=1';
  }

  @override
  Widget build(BuildContext context) {
    log("-----path - ${widget.fullIFrame}");

    return IgnorePointer(
      ignoring: true,
      child: Html(
        data: widget.fullIFrame ?? false
            ? '<html><iframe height="230" style="width:100%" src="$path" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe></html>'
            : '<html><img src="https://img.youtube.com/vi/${widget.videoId}/0.jpg" width="100%" height="auto"></html>',
      ),
    ).onTap(() {
      launchUrls(path!, forceWebView: true);
    });
  }
}
