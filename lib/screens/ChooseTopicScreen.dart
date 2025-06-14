import 'dart:convert';

import 'package:facebook_audience_network/ad/ad_rewarded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../components/AdmobComponent.dart';
import '../components/AppWidgets.dart';
import '../components/CategoryItemWidget.dart';
import '../components/FacebookComponent.dart';
import '../models/CategoryData.dart';
import '../network/RestApis.dart';
import '../shimmer/TopicShimmer.dart';
import '../../../utils/extension.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppLocalizations.dart';
import '../main.dart';

class ChooseTopicScreen extends StatefulWidget {
  static String tag = '/ChooseTopicScreen';

  @override
  ChooseTopicScreenState createState() => ChooseTopicScreenState();
}

class ChooseTopicScreenState extends State<ChooseTopicScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setDynamicStatusBarColor();
    if (isEnableAds)
    if (adEnableOnChooseTopic) {
      if (getStringAsync(reward) == facebookAudience) {
        await loadFaceBookRewardedVideoAd(onCall: () async {
          save();
        });
      }
    }
  }

  Future<void> save() async {
    hideKeyboard(context);

    if (appStore.isLoggedIn) {
      appStore.isLoading = true;
      setState(() {});

      bool? res = await updateProfile(toastMessage: 'Your topic hase been saved');

      appStore.isLoading = false;
      setState(() {});

      if ((res ?? false) && mounted) finish(context, true);
    }
  }

  List<CategoryData> getInitialData() {
    List<CategoryData> list = [];
    String s = getStringAsync(CATEGORY_DATA);

    if (s.isNotEmpty) {
      Iterable it = jsonDecode(s);
      list.addAll(it.map((e) => CategoryData.fromJson(e)).toList());
    }

    return list;
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
      child: Scaffold(
        appBar: appBarWidget(
          appLocalization.translate('choose_Topics'),
          showBack: true,
          elevation: 0,
          color: getAppBarWidgetBackGroundColor(),
          textColor: getAppBarWidgetTextColor(),
          actions: [
            IconButton(
                icon: Icon(Icons.check, color: white),
                onPressed: () async {
                  if (isEnableAds)
                  if (adEnableOnChooseTopic) {
                    if (getStringAsync(reward) == facebookAudience) {
                      FacebookRewardedVideoAd.showRewardedVideoAd();
                    } else {
                      showAdMobRewardedAd(onCall: () {
                        save();
                      });
                    }
                  } else {
                    save();
                  }
                }),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            FutureBuilder<List<CategoryData>>(
              initialData: getStringAsync(CATEGORY_DATA).isEmpty ? null : getInitialData(),
              future: getCategories(),
              builder: (_, snap) {
                if (snap.hasData) {
                  if (snap.data!.isNotEmpty) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.only(top: 8),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 12,
                        alignment: WrapAlignment.spaceEvenly,
                        children: snap.data!.map((data) {
                          return CategoryItemWidget(data);
                        }).toList(),
                      ).paddingSymmetric(horizontal: 10),
                    );
                  } else {
                    return noDataWidget(context);
                  }
                }

                return snapWidgetHelper(
                  snap,
                  loadingWidget: TopicShimmer(),
                );
              },
            ),
            Observer(builder: (_) => Loader().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
