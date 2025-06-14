import 'package:flutter/material.dart';
import '../../../components/BreakingNewsMarqueeWidget.dart';

import '../../../components/VideoListWidget.dart';
import '../../../components/ViewAllHeadingWidget.dart';
import '../../../components/home3/components/Dashboard3BreakingNewsListWidget.dart';
import '../../../components/home3/components/Dashboard3NewsListWidget.dart';
import '../../../models/DashboardResponse.dart';
import '../../../screens/ViewAllNewsScreen.dart';
import '../../../screens/ViewAllVideoScreen.dart';
import '../../../utils/extension.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../AppLocalizations.dart';
import '../QuickReadWidget.dart';
import '../StoryListWidget.dart';
import '../TwitterFeedListWidget.dart';

class Dashboard3Widget extends StatefulWidget {
  final AsyncSnapshot<DashboardResponse> snap;

  Dashboard3Widget(this.snap);

  @override
  Dashboard3WidgetState createState() => Dashboard3WidgetState();
}

class Dashboard3WidgetState extends State<Dashboard3Widget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return SafeArea(
      top: !isIOS ? true : false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BreakingNewsMarqueeWidget(data: widget.snap.data!.breaking_post),
            StoryListWidget(list: widget.snap.data!.story_post, backgroundColor: white, textColor: scaffoldColorDark),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                20.height,
                ViewAllHeadingWidget(
                  title: appLocalization.translate('breaking_News').toUpperCase(),
                  backgroundColor: white,
                  textColor: scaffoldColorDark,
                  onTap: () {
                    ViewAllNewsScreen(title: 'breaking_News', req: {'posts_per_page': postsPerPage, FILTER: FILTER_FEATURE}).launch(context);
                  },
                ),
                8.height,
                Dashboard3BreakingNewsListWidget(widget.snap.data!.breaking_post),
              ],
            ).visible(widget.snap.data!.breaking_post.validate().isNotEmpty),
            // Quick Read
            QuickReadWidget(widget.snap.data!.recent_post),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                16.height,
                ViewAllHeadingWidget(
                  title: appLocalization.translate('recent_News').toUpperCase(),
                  textColor: scaffoldColorDark,
                  backgroundColor: white,
                  onTap: () {
                    ViewAllNewsScreen(title: 'recent_News', req: {'posts_per_page': postsPerPage}).launch(context);
                  },
                ),
                8.height,
                Dashboard3NewsListWidget(widget.snap.data!.recent_post, padding: EdgeInsets.symmetric(horizontal: 8)),
              ],
            ).visible(widget.snap.data!.recent_post.validate().isNotEmpty),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                16.height,
                ViewAllHeadingWidget(
                  title: appLocalization.translate('videos').toUpperCase(),
                  backgroundColor: white,
                  textColor: scaffoldColorDark,
                  onTap: () {
                    ViewAllVideoScreen().launch(context);
                  },
                ),
                8.height,
                VideoListWidget(widget.snap.data!.videos.validate(), axis: Axis.horizontal),
              ],
            ).visible(widget.snap.data!.videos.validate().isNotEmpty),
            16.height,
            //Show Twitter Widget only if you have not disabled in your Word-Press Admin panel
            TwitterFeedListWidget(backgroundColor: white, textColor: scaffoldColorDark),
          ],
        ),
      ),
    );
  }
}
