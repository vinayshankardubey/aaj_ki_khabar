import 'package:flutter/material.dart';
import '../../../models/DashboardResponse.dart';
import '../../../utils/extension.dart'as m;

import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../utils/extension.dart';

class BreakingNewsMarqueeWidget extends StatefulWidget {
  static String tag = '/BreakingNewsMarqueeWidget';
  final List<NewsData>? data;

  BreakingNewsMarqueeWidget({this.data});

  @override
  BreakingNewsMarqueeWidgetState createState() => BreakingNewsMarqueeWidgetState();
}

class BreakingNewsMarqueeWidgetState extends State<BreakingNewsMarqueeWidget> {
  String mBreakingNewsMarquee = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    widget.data!.forEach((element) {
      if (widget.data!.indexOf(element) != 0) {
        mBreakingNewsMarquee = mBreakingNewsMarquee + '   |   ';
      } else {
        mBreakingNewsMarquee = '     ';
      }

      mBreakingNewsMarquee = mBreakingNewsMarquee + element.post_title!;
    });

    /// Append your copy right text to Headline
    if (getStringAsync(COPYRIGHT_TEXT).isNotEmpty) mBreakingNewsMarquee = mBreakingNewsMarquee + '  |  ' + getStringAsync(COPYRIGHT_TEXT);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (getBoolAsync(DISABLE_HEADLINE_WIDGET)) return SizedBox();
    if (widget.data.validate().isEmpty) return SizedBox();

    return Container(
      height: 45.0,
      width: context.width(),
      decoration: BoxDecoration(boxShadow: defaultBoxShadow(), color: appStore.isDarkMode ? black : white),
      child: m.Marquee(
        text: mBreakingNewsMarquee,
        style: boldTextStyle(),
        pauseAfterRound: 2.seconds,
        startAfter: 1.seconds,
      ),
    );
  }
}
