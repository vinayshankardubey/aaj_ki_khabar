import 'package:flutter/material.dart';
import '../../main.dart';
import '../../models/DashboardResponse.dart';
import '../../screens/NewsDetailScreen.dart';
import '../../../utils/extension.dart';
import 'package:nb_utils/nb_utils.dart';

class NewsDetailListScreen extends StatefulWidget {
  final List<NewsData>? newsData;
  final int index;
  static String tag = '/NewsDetailListScreen';

  NewsDetailListScreen(this.newsData, {this.index = 0});

  @override
  NewsDetailListScreenState createState() => NewsDetailListScreenState();
}

class NewsDetailListScreenState extends State<NewsDetailListScreen> {

  PageController? pageController;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    print("News Detail Screen Navigating");
    pageController = PageController(initialPage: widget.index);

  }




  @override
  void dispose() {
    setDynamicStatusBarColor(milliseconds: 0);

    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: pageController,
          children: widget.newsData!.map((e) =>  NewsDetailScreen(newsData: e, heroTag: '${e.iD}${currentTimeStamp()}', disableAd: true)).toList(),
        ),

      ],
    );
  }
}
