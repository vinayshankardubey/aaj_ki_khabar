import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:flutter/material.dart';
import '../components/NewsItemWidget.dart';
import '../models/DashboardResponse.dart';
import '../screens/NewsDetailScreen.dart';
import '../../../utils/extension.dart';
import 'package:nb_utils/nb_utils.dart';


// ignore: must_be_immutable
class NewsListWidget extends StatefulWidget {
  static String tag = '/NewsListWidget';
  List<NewsData>? newsList;
  bool? enableScrolling;
  EdgeInsetsGeometry? padding;

  NewsListWidget(this.newsList, {this.enableScrolling, this.padding});

  @override
  NewsListWidgetState createState() => NewsListWidgetState();
}

class NewsListWidgetState extends State<NewsListWidget> {
  int adIndex = 4;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: widget.padding ?? EdgeInsets.all(0),
        itemCount: widget.newsList!.length,
        shrinkWrap: true,
        physics: widget.enableScrolling.validate() ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          NewsData item = widget.newsList![index];
          int num =  widget.newsList!.length>5?5:widget.newsList!.length;
          if (index == num && isAdEnableBetweenList == true && isEnableAds==true) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NewsItemWidget(
                  item,
                  onTap: () {
                    NewsDetailScreen(id: item.iD.toString(), disableAd: false, newsData: item).launch(context);
                  },
                ),
              ],
            );
          } else {
            return NewsItemWidget(
              item,
              onTap: () {
                NewsDetailScreen(id: item.iD.toString(), disableAd: false, newsData: item).launch(context);
              },
            );
          }
        },
      ),
    );
  }
}
