import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../components/AppWidgets.dart';
import '../../../components/VideoListWidget.dart';
import '../../../models/DashboardResponse.dart';
import '../../../network/RestApis.dart';
import '../../../utils/extension.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppLocalizations.dart';
import '../main.dart';

class ViewAllVideoScreen extends StatefulWidget {
  static String tag = '/ViewAllVideoScreen';

  @override
  ViewAllVideoScreenState createState() => ViewAllVideoScreenState();
}

class ViewAllVideoScreenState extends State<ViewAllVideoScreen> {
  ScrollController scrollController = ScrollController();

  int page = 1;
  bool isLastPage = false;

  List<VideoData> videos = [];

  @override
  void initState() {
    super.initState();
    init();

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (!isLastPage) {
          page++;
          loadVideos();
        }
      }
    });
  }

  Future<void> init() async {
    setDynamicStatusBarColor(milliseconds: 500);
    loadVideos();
  }

  Future<void> loadVideos() async {
    appStore.setLoading(true);

    await getVideos(page).then((value) async {
      isLastPage = value.validate().length != postsPerPage;

      if (page == 1) {
        videos.clear();
      }
      videos.addAll(value);

      appStore.setLoading(false);
    }).catchError((e) {
      toast(e.toString());
      appStore.setLoading(false);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setDynamicStatusBarColor();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocale = AppLocalizations.of(context)!;

    return SafeArea(
      top: !isIOS ? true : false,
      child: Scaffold(
        appBar: appBarWidget(
          appLocale.translate('videos'),
          showBack: true,
          color: getAppBarWidgetBackGroundColor(),
          textColor: getAppBarWidgetTextColor(),
        ),
        body: Observer(
          builder: (_) => Stack(
            children: [
              VideoListWidget(videos, axis: Axis.vertical, scrollController: scrollController),
              noDataWidget(context).visible(!appStore.isLoading && videos.isEmpty),
              Positioned(
                bottom: page == 1 ? null : 0,
                child: Loader().center().visible(appStore.isLoading),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
