import 'package:flutter/material.dart';
import '../../../components/home2/component/DashBoard2BreakingNewsItemWidget.dart';
import '../../../models/DashboardResponse.dart';
import '../../../screens/NewsDetailListScreen.dart';
import '../../../utils/extension.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';

class DashBoard2BreakingNewsListWidget extends StatefulWidget {
  static String tag = '/BreakingNewsListWidget';
  final List<NewsData>? newsList;

  DashBoard2BreakingNewsListWidget(this.newsList);

  @override
  DashBoard2BreakingNewsListWidgetState createState() => DashBoard2BreakingNewsListWidgetState();
}

// ignore: deprecated_member_use
class DashBoard2BreakingNewsListWidgetState extends State<DashBoard2BreakingNewsListWidget> with AfterLayoutMixin<DashBoard2BreakingNewsListWidget> {
  PageController pageController = PageController();

  double? currentPage = 0;

  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //setDynamicStatusBarColor();
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page;
      });
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    pages = widget.newsList!
        .asMap()
        .map((index, e) {
          return MapEntry(index, DashBoard2BreakingNewsItemWidget(e, onTap: () => NewsDetailListScreen(widget.newsList, index: index).launch(context)));
        })
        .values
        .toList();
    setState(() {});
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getDashBoard2WidgetHeight(),
      child: Stack(
        children: [
          PageView(controller: pageController, children: pages.map((e) => e).toList()),
          16.height,
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: DotIndicator(
              pageController: pageController,
              pages: pages,
              unselectedIndicatorColor: white,
              indicatorColor: appStore.isDarkMode ? gray : getAppPrimaryColor(),
              dotSize: 5,
              onDotTap: (s) {
                pageController.animateToPage(s, duration: 5.milliseconds, curve: Curves.bounceIn);
              },
            ),
          ),
        ],
      ),
    );
  }
}
