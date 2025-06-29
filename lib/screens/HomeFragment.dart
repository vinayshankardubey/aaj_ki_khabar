import 'dart:convert';

import 'package:flutter/material.dart';
import '../components/HeaderWidget.dart';
import '../components/WeatherWidget.dart';
import '../components/home1/Dashboard1Widget.dart';
import '../components/home2/Dashboard2Widget.dart';
import '../components/home3/Dashboard3Widget.dart';
import '../models/DashboardResponse.dart';
import '../network/RestApis.dart';
import '../shimmer/HorizontalImageShimmer.dart';
import '../shimmer/VerticalTextImageShimmer.dart';
import '../../../utils/extension.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeFragment extends StatefulWidget {
  static String tag = '/HomeFragment';

  @override
  HomeFragmentState createState() => HomeFragmentState();
}

class HomeFragmentState extends State<HomeFragment> {

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget getHomeWidget(AsyncSnapshot<DashboardResponse> snap) {
      if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 1) {
        return Dashboard1Widget(snap);
      } else if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 2) {
        return Dashboard2Widget(snap);
      } else if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 3) {
        return Dashboard3Widget(snap);
      } else {
        return Dashboard1Widget(snap);
      }
    }

    return Container(
      height: context.height(),
      width: context.width(),
      child: NestedScrollView(
        headerSliverBuilder: (_, isScroll) {
          return [
            SliverAppBar(
              expandedHeight: !getBoolAsync(DISABLE_LOCATION_WIDGET) ? 100 : 70,
              floating: false,
              pinned: false,
              backgroundColor: getAppBarWidgetBackGroundColor(),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Container(
                  height: !getBoolAsync(DISABLE_LOCATION_WIDGET) ? 100 : 70,
                  color: getAppBarWidgetBackGroundColor(),
                  child: !getBoolAsync(DISABLE_LOCATION_WIDGET) ? HeaderWidget() : WeatherWidget(),
                ),
              ),
            ),
          ];
        },
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
            await Future.delayed(Duration(seconds: 2));
          },
          child: FutureBuilder<DashboardResponse>(
            initialData: getStringAsync(DASHBOARD_DATA).isEmpty ? null : DashboardResponse.fromJson(jsonDecode(getStringAsync(DASHBOARD_DATA))),
            future: getDashboardApi({'posts_per_page': postsPerPage}, 1),
            builder: (_, snap) {

              if (snap.hasData) {
                return getHomeWidget(snap);
              }
              return snapWidgetHelper(
                snap,
                errorWidget: Container(
                  child: Text("hello", style: primaryTextStyle().copyWith(color: Colors.red)).paddingAll(16).center(),
                  height: context.height() - 180,
                  width: context.width(),
                ),
                loadingWidget: SingleChildScrollView(
                  child: Column(
                    children: [
                      16.height,
                      HorizontalImageShimmer(),
                      16.height,
                      HorizontalImageShimmer(),
                      16.height,
                      VerticalTextImageShimmer(),
                      16.height,
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
