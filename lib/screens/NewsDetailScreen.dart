import 'dart:async';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:share_plus/share_plus.dart';
import '../../../components/AdmobComponent.dart';
import '../../../components/DetailPageVariant1Widget.dart';
import '../../../components/DetailPageVariant2Widget.dart';
import '../../../components/DetailPageVariant3Widget.dart';
import '../../../components/FacebookComponent.dart';
import '../../../models/DashboardResponse.dart';
import '../../../network/RestApis.dart';
import '../../../screens/LoginScreen.dart';
import '../../../screens/ReadAloudScreen.dart';
import '../../../utils/extension.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

// ignore: must_be_immutable
class NewsDetailScreen extends StatefulWidget {
  static String tag = '/NewsDetailScreen';
  NewsData? newsData;
  final String? heroTag;
  String? id;
  final bool disableAd;

  NewsDetailScreen({this.newsData, this.heroTag, this.id, this.disableAd = true});

  @override
  NewsDetailScreenState createState() => NewsDetailScreenState();
}

class NewsDetailScreenState extends State<NewsDetailScreen> {
  Timer? timer;

  bool isBookmark = false;
  bool isShare = false;
  bool isPlay = false;

  String postContent = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    print("============ New Detail Screen ==================");
    FacebookAudienceNetwork.init(iOSAdvertiserTrackingEnabled: false);
    setDynamicStatusBarColorDetail(milliseconds: 400);

    if (widget.newsData != null) {
      setPostContent(widget.newsData!.post_content.validate());
      widget.id = widget.newsData!.iD.toString();
    }

    if (await isNetworkAvailable()) {
      getBlogDetail({'post_id': widget.id.toString()}, appStore.isLoggedIn).then((value) {
        widget.newsData = value;
        setPostContent(value.post_content);
      });
    } else {
      setPostContent(widget.newsData!.post_content);
    }

    if (isInterstitialAdsEnable == true && isEnableAds == true) {
      loadAd();
      showAd();
    }

    if (getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == 1) {
      if (isEnableAds) if (adEnableOnShare || adEnableOnBookmark || adEnableOnPlay) {
        if (getStringAsync(reward) == facebookAudience) {
          loadRewardAd();
        } else {
        }
      }
    }
  }

  void loadBlogDetail() {
    getBlogDetail({'post_id': widget.id.toString()}, appStore.isLoggedIn).then((value) {
      widget.newsData = value;
      setPostContent(value.post_content);
    });
  }

  Future<void> setPostContent(String? text) async {
    postContent = widget.newsData!.post_content
        .validate()
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('[embed]', '<embed>')
        .replaceAll('[/embed]', '</embed>')
        .replaceAll('[caption]', '<caption>')
        .replaceAll('[/caption]', '</caption>');

    setState(() {});
  }

  loadAd() {
    if (getStringAsync(interstitial) == facebookAudience) {
      loadFaceBookInterstitialAd();
    } else {
    }
  }

  loadRewardAd() {
    loadFaceBookRewardedVideoAd(onCall: () async {
      if (isPlay == true) {
        ReadAloudScreen(parseHtmlString(postContent)).launch(context);
      } else if (isShare == true) {
        Share.share(widget.newsData!.share_url.validate());
      } else {
        if (!appStore.isLoggedIn) {
          bool? res = await LoginScreen(isNewTask: false).launch(context);
          if (res ?? false) {
            addToWishList();
          }
        } else {
          addToWishList();
        }
      }
    });
  }

  showAd() {
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      if (getStringAsync(interstitial) == facebookAudience) {
        showFacebookInterstitialAd();
      } else {
      }
    });
  }



  @override
  void dispose() async {
    timer!.cancel();
    super.dispose();
  }

  Future<void> addToWishList() async {
    Map req = {
      'post_id': widget.newsData!.iD,
    };

    if (!widget.newsData!.is_fav.validate()) {
      addWishList(req).then((res) {
        appStore.isLoading = false;
        LiveStream().emit(refreshBookmark, true);
        toast(res['message']);
      }).catchError((error) {
        widget.newsData!.is_fav = !widget.newsData!.is_fav.validate();
        appStore.isLoading = false;
        toast(error.toString());
      });
    } else {
      removeWishList(req).then((res) {
        appStore.isLoading = false;

        LiveStream().emit(refreshBookmark, true);

        toast(res.message.validate());
      }).catchError((error) {
        widget.newsData!.is_fav = !widget.newsData!.is_fav.validate();

        appStore.isLoading = false;
        log(error.toString());
      });
    }

    widget.newsData!.is_fav = !widget.newsData!.is_fav.validate();

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget getVariant(int postView, List<NewsData> relatedNews) {
      if (getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == 1) {
        return DetailPageVariant1Widget(widget.newsData, postView: postView, postContent: postContent, relatedNews: relatedNews.validate(), heroTag: widget.heroTag);
      } else if (getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == 2) {
        return DetailPageVariant2Widget(widget.newsData, postView: postView, postContent: postContent, relatedNews: relatedNews.validate(), heroTag: widget.heroTag);
      } else if (getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == 3) {
        return DetailPageVariant3Widget(widget.newsData, postView: postView, postContent: postContent, relatedNews: relatedNews.validate());
      } else {
        return DetailPageVariant1Widget(widget.newsData, postView: postView, postContent: postContent, relatedNews: relatedNews.validate(), heroTag: widget.heroTag);
      }
    }

    return SafeArea(
      top: !isIOS ? true : false,
      child: Scaffold(
        appBar: (getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == 1 && widget.newsData != null)
            ? appBarWidget(
                parseHtmlString(widget.newsData != null ? widget.newsData!.post_title.validate() : ''),
                showBack: true,
                color: getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) != 1 ? Theme.of(context).cardColor : getAppPrimaryColor(),
                textColor: getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) != 1 ? textPrimaryColorGlobal : Colors.white,
                actions: [
                  if (widget.newsData != null)
                    IconButton(
                      icon: Icon(
                        widget.newsData!.is_fav.validate() ? FontAwesome.bookmark : FontAwesome.bookmark_o,
                        color: (getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == 1 && getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 1) || appStore.isDarkMode
                            ? Colors.white
                            : Colors.black,
                      ),
                      onPressed: () async {
                        if (adEnableOnBookmark && isEnableAds) {
                          if (getStringAsync(reward) == facebookAudience) {
                            isBookmark = true;
                            isShare = false;
                            isPlay = false;
                            setState(() {});
                            if (isRewardedAdLoaded == true) {
                              FacebookRewardedVideoAd.showRewardedVideoAd();
                            } else {
                              if (!appStore.isLoggedIn) {
                                bool? res = await LoginScreen(isNewTask: false).launch(context);

                                if (res ?? false) {
                                  addToWishList();
                                }
                              } else {
                                addToWishList();
                              }
                            }
                            // });
                          } else {

                          }
                        } else {
                          if (!appStore.isLoggedIn) {
                            bool? res = await LoginScreen(isNewTask: false).launch(context);

                            if (res ?? false) {
                              addToWishList();
                            }
                          } else {
                            addToWishList();
                          }
                        }
                      },
                    ),
                  IconButton(
                      icon: Icon(
                        Icons.share_rounded,
                        color: (getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == 1 && getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 1) || appStore.isDarkMode
                            ? Colors.white
                            : Colors.black,
                      ),
                      onPressed: () async {
                        if (adEnableOnShare && isEnableAds) {
                          if (getStringAsync(reward) == facebookAudience) {
                            isShare = true;
                            isBookmark = false;
                            isPlay = false;
                            setState(() {});
                            if (isRewardedAdLoaded == true) {
                              FacebookRewardedVideoAd.showRewardedVideoAd();
                            } else {
                              Share.share(widget.newsData!.share_url.validate());
                            }
                          } else {

                          }
                        } else {
                          Share.share(widget.newsData!.share_url.validate());
                        }
                      }),
                  IconButton(
                    icon: Icon(
                      Icons.play_circle_outline,
                      color: (getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == 1 && getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == 1) || appStore.isDarkMode
                          ? Colors.white
                          : Colors.black,
                    ),
                    onPressed: () async {
                      if (adEnableOnPlay && isEnableAds) {
                        if (getStringAsync(reward) == facebookAudience) {
                          isPlay = true;
                          isBookmark = false;
                          isShare = false;
                          setState(() {});
                          if (isRewardedAdLoaded == true) {
                            FacebookRewardedVideoAd.showRewardedVideoAd();
                          } else {
                            ReadAloudScreen(parseHtmlString(postContent)).launch(context);
                          }
                        } else {

                        }
                      } else {
                        ReadAloudScreen(parseHtmlString(postContent)).launch(context);
                      }
                    },
                  ),
                ],
              )
            : null,
        body: widget.newsData != null
            ? Container(
                height: context.height(),
                width: context.width(),
                child: Stack(
                  children: [
                    getVariant(widget.newsData!.post_view.validate(), widget.newsData!.related_news.validate()),
                  ],
                ),
              )
            : Loader(),
      ),
    );
  }
}
