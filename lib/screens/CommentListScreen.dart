import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import '../AppLocalizations.dart';
import '../components/AdmobComponent.dart';
import '../components/AppWidgets.dart';
import '../components/FacebookComponent.dart';
import '../components/PostCommentDialog.dart';
import '../main.dart';
import '../models/CommentData.dart';
import '../network/RestApis.dart';
import '../screens/LoginScreen.dart';
import '../../../utils/extension.dart';
import 'package:nb_utils/nb_utils.dart';

class CommentListScreen extends StatefulWidget {
  static String tag = '/CommentListScreen';
  final int? id;

  CommentListScreen(this.id);

  @override
  CommentListScreenState createState() => CommentListScreenState();
}

class CommentListScreenState extends State<CommentListScreen> {

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    FacebookAudienceNetwork.init(
      iOSAdvertiserTrackingEnabled: false,
    );
    setDynamicStatusBarColor(milliseconds: 400);

    if (isInterstitialAdsEnable == true && isEnableAds==true) {
      loadAd();
    }
    if (adEnableOnAddComment == true && isEnableAds==true) {
      if (getStringAsync(reward) == facebookAudience) {
        loadRewardAd();
      }
    }
  }

  loadAd() {
    if (getStringAsync(interstitial) == facebookAudience) {
      loadFaceBookInterstitialAd();
    } else {
    }
    showAd();
  }

  loadRewardAd() async {
    await loadFaceBookRewardedVideoAd(onCall: () async {
      mAddComment();
    });
  }

  @override
  void dispose() async {
    if (isInterstitialAdsEnable == true && isEnableAds==true)
    super.dispose();
  }

  Future<void> mAddComment() async {
    if (appStore.isLoggedIn) {
      bool? res = await showInDialog(context, builder: (context) => PostCommentDialog(widget.id));
      if (res ?? false) {
        setState(() {});
      }
    } else {
      LoginScreen(isNewTask: false).launch(context);
    }
  }

  showAd() {
    if (getStringAsync(interstitial) == facebookAudience) {
      showFacebookInterstitialAd();
    } else {
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context);

    Widget commentTile(CommentData? data){
     return Row(
       mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(parseHtmlString(data!.authorName.validate().removeAllWhiteSpace()), style: boldTextStyle()),
              4.height,
              Text(parseHtmlString(data.content!.rendered.validate()), style: secondaryTextStyle()),
            ],
          ).expand(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(appLocalization!.translate('swipe_right_to_delete'), style: secondaryTextStyle(size: 8)).visible(data.isMyComment),
              8.height,
              Text(DateFormat('dd MMM, yyyy  HH:mm').format(DateTime.parse(data.date.validate())), style: secondaryTextStyle(size: 10)),
            ],
          ),
        ],
      );
    }

    return Observer(
      builder: (_) => SafeArea(
        top: !isIOS ? true : false,
        child: Scaffold(
          appBar: appBarWidget(
            appLocalization!.translate('Comments'),
            showBack: true,
            color: getAppBarWidgetBackGroundColor(),
            textColor: getAppBarWidgetTextColor(),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                color: getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 1 || appStore.isDarkMode ? Colors.white : Colors.black,
                onPressed: () async {
                  if (adEnableOnAddComment && isEnableAds) {
                    if (appStore.isLoggedIn) {
                      if (getStringAsync(reward) == facebookAudience) {
                        FacebookRewardedVideoAd.showRewardedVideoAd();
                      } else {
                      }
                    } else {
                      LoginScreen(isNewTask: false).launch(context);
                    }
                  } else {
                    mAddComment();
                  }
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              FutureBuilder<List<CommentData>>(
                future: getCommentList(widget.id),
                builder: (_, snap) {
                  if (snap.hasData) {
                    if (snap.data!.isNotEmpty) {
                      return ListView.separated(
                        itemCount: snap.data!.length,
                        padding: EdgeInsets.only(left: 16.0,right: 16,bottom: 16,top: 16),
                        shrinkWrap: true,
                        separatorBuilder: (_, index) => Divider(height: 0).paddingBottom(16),
                        itemBuilder: (_, index) {
                          CommentData data = snap.data![index];
                          return  data.isMyComment ?Dismissible(
                            background: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                height: context.height(),
                                width: context.width() * 0.30,
                                color: appStore.isDarkMode ? Theme.of(context).cardColor : colorPrimary,
                                child: Icon(Icons.delete, color: white).onTap(() {}),
                              ),
                            ),
                            onDismissed: (DismissDirection direction) {
                              snap.data!.removeAt(index);
                            },
                            key: ValueKey(snap.data![index]),
                            child: commentTile(snap.data![index]),
                            confirmDismiss: (DismissDirection direction) async {
                              return showConfirmDialog(
                                context,
                                appLocalization.translate('delete_dialog'),
                                positiveText: appLocalization.translate('yes'),
                                negativeText: appLocalization.translate('no'),
                                onAccept: () {
                                  if (getBoolAsync(IS_LOGGED_IN)) {
                                    if (data.isMyComment) {
                                      appStore.setLoading(true);
                                      removeComment(id: data.id).then((value) {
                                        appStore.setLoading(false);
                                      }).catchError((e){log(e);
                                      });
                                    }
                                  } else {
                                    toast(appLocalization.translate('please_log_in'));
                                  }
                                },
                              );
                            },
                          ):commentTile(snap.data![index]);
                        },
                      );
                    } else {
                      return noDataWidget(context);
                    }
                  }
                  return snapWidgetHelper(snap);
                },
              ),
              Loader().visible(appStore.isLoading),
            ],
          ),
        ),
      ),
    );
  }
}
