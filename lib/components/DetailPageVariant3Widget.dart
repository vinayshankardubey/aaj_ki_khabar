import 'dart:ui';

import 'package:facebook_audience_network/ad/ad_rewarded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:share_plus/share_plus.dart';
import '../../../main.dart';
import '../../../models/DashboardResponse.dart';
import '../../../network/RestApis.dart';
import '../../../screens/CommentListScreen.dart';
import '../../../screens/LoginScreen.dart';
import '../../../utils/extension.dart';
import 'package:nb_utils/nb_utils.dart';
import '../AppLocalizations.dart';
import 'AdmobComponent.dart';
import 'AppWidgets.dart';
import 'BreakingNewsListWidget.dart';
import 'CommentTextWidget.dart';
import 'FacebookComponent.dart';
import 'HtmlWidget.dart';
import 'ReadAloudDialog.dart';

// ignore: must_be_immutable
class DetailPageVariant3Widget extends StatefulWidget {
  static String tag = '/DetailPageVariant3Widget';

  NewsData? newsData;
  final int? postView;
  final String? postContent;
  final List<NewsData>? relatedNews;

  DetailPageVariant3Widget(this.newsData, {this.postView, this.postContent, this.relatedNews});

  @override
  DetailPageVariant3WidgetState createState() => DetailPageVariant3WidgetState();
}

class DetailPageVariant3WidgetState extends State<DetailPageVariant3Widget> {
  bool isBookmark = false;
  bool isShare = false;
  bool isPlay = false;
  bool? isLike;

  int? count;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setDynamicStatusBarColorDetail(milliseconds: 400);
    isLike = widget.newsData!.is_like.validate();
    count = widget.newsData!.like_count;
    if (isEnableAds)
    if (adEnableOnShare || adEnableOnBookmark || adEnableOnPlay) {
      if (getStringAsync(reward) == facebookAudience) {
        loadRewardAd();
      }
    }
  }

  Future<void> likeDislike(int id) async {
    Map req = {'post_id': id};
    blogLikeDisLike(req: req).then((res) {
      if (res.isLike == true) {
        count = count! + 1;
      } else {
        count = count! - 1;
      }
      isLike = res.isLike!;
      toast(res.message);
      setState(() {});
    }).catchError((error) {
      appStore.isLoading = false;
      toast(error.toString());
    });
  }

  loadRewardAd() {
    loadFaceBookRewardedVideoAd(onCall: () async {
      if (isPlay == true) {
        showAdMobRewardedAd(onCall: () {
          showInDialog(
            context,
            builder: (context) => ReadAloudDialog(parseHtmlString(widget.postContent)),
            contentPadding: EdgeInsets.zero,
            barrierDismissible: false,
          );
        });
      } else if (isShare == true) {
        Share.share(widget.newsData!.share_url.validate());
      } else {
        mBookmark();
      }
    });
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
        appStore.isLoading = false;
        toast(error.toString());
      });
    } else {
      removeWishList(req).then((res) {
        appStore.isLoading = false;

        LiveStream().emit(refreshBookmark, true);

        toast(res.message.validate());
      }).catchError((error) {
        appStore.isLoading = false;
        toast(error.toString());
      });
    }

    widget.newsData!.is_fav = !widget.newsData!.is_fav.validate();
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> mBookmark() async {
    if (!appStore.isLoggedIn) {
      bool? res = await LoginScreen(isNewTask: false).launch(context);
      if (res ?? false) {
        addToWishList();
      }
    } else {
      addToWishList();
    }
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return Container(
      child: Stack(
        children: [
          cachedImage(widget.newsData!.full_image.validate(), height: context.height(), fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(color: Colors.black26),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 8, right: 8, top: context.statusBarHeight, bottom: 80),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.arrow_back).onTap(() {
                                finish(context);
                              }),
                              decoration: BoxDecoration(color: context.scaffoldBackgroundColor, shape: BoxShape.circle),
                            ),
                            8.width,
                            Wrap(
                              alignment: WrapAlignment.start,
                              runSpacing: 4.0,
                              runAlignment: WrapAlignment.center,
                              spacing: 2.0,
                              children: [
                                Icon(Icons.access_time_rounded, color: Colors.white, size: 16),
                                4.width,
                                Text(widget.newsData!.human_time_diff.validate(), style: secondaryTextStyle(color: Colors.white)),
                                4.width,
                                Text('・', style: secondaryTextStyle(color: Colors.white)),
                                Text(getArticleReadTime(context, widget.newsData!.post_content.validate()), style: secondaryTextStyle(color: Colors.white)),
                              ],
                            ).expand(),
                          ],
                        ).expand(),
                        Row(
                          children: [
                            IconButton(
                              icon: Container(
                                child: Icon(widget.newsData!.is_fav.validate() ? FontAwesome.bookmark : FontAwesome.bookmark_o, size: 18),
                                decoration: BoxDecoration(color: context.scaffoldBackgroundColor, shape: BoxShape.circle),
                                padding: EdgeInsets.all(6),
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
                                      mBookmark();
                                    }
                                  } else {
                                    showAdMobRewardedAd(onCall: () async {
                                      mBookmark();
                                    });
                                  }
                                } else {
                                  mBookmark();
                                }
                              },
                            ),
                            IconButton(
                              icon: Container(
                                child: Icon(Icons.share_rounded, size: 18),
                                decoration: BoxDecoration(color: context.scaffoldBackgroundColor, shape: BoxShape.circle),
                                padding: EdgeInsets.all(6),
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
                                    showAdMobRewardedAd(onCall: () {
                                      Share.share(widget.newsData!.share_url.validate());
                                    });
                                  }
                                } else {
                                  Share.share(widget.newsData!.share_url.validate());
                                }
                              },
                            ),
                            IconButton(
                              icon: Container(
                                child: Icon(Icons.play_circle_outline, size: 18),
                                decoration: BoxDecoration(color: context.scaffoldBackgroundColor, shape: BoxShape.circle),
                                padding: EdgeInsets.all(6),
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
                                      showAdMobRewardedAd(onCall: () {
                                        showInDialog(
                                          context,
                                          builder: (context) => ReadAloudDialog(parseHtmlString(widget.postContent)),
                                          contentPadding: EdgeInsets.zero,
                                          barrierDismissible: false,
                                        );
                                      });
                                    }
                                  } else {
                                    showAdMobRewardedAd(onCall: () {
                                      showInDialog(
                                        context,
                                        builder: (context) => ReadAloudDialog(parseHtmlString(widget.postContent)),
                                        contentPadding: EdgeInsets.zero,
                                        barrierDismissible: false,
                                      );
                                    });
                                  }
                                } else {
                                  showInDialog(
                                    context,
                                    builder: (context) => ReadAloudDialog(parseHtmlString(widget.postContent)),
                                    contentPadding: EdgeInsets.zero,
                                    barrierDismissible: false,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    16.height,
                    if (widget.newsData!.category.validate().isNotEmpty) getPostCategoryTagWidget(context, widget.newsData!).withSize(height: 40, width: context.width()).paddingLeft(8),
                    Text(parseHtmlString(widget.newsData!.post_title.validate()), style: boldTextStyle(size: 40, fontFamily: titleFont(), color: Colors.white)).paddingOnly(left: 8, right: 8),
                    8.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(FontAwesome.commenting_o, size: 16, color: Colors.white),
                            8.width,
                            CommentTextWidget(text: widget.newsData!.no_of_comments_text.validate(value: '0'), textColor: Colors.white),
                          ],
                        ).paddingOnly(left: 8, right: 8, top: 8, bottom: 8).onTap(() async {
                          await CommentListScreen(widget.newsData!.iD).launch(context);
                          await Future.delayed(Duration(milliseconds: 300));

                          setStatusBarColor(Colors.transparent);
                        }),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(FontAwesome.eye, size: 16, color: Colors.white),
                            8.width,
                            Text(widget.postView.validate().toString(), style: secondaryTextStyle(color: Colors.white)),
                            16.width,
                            Row(
                              children: [
                                Icon(isLike == true ? Icons.thumb_up : Icons.thumb_up_alt_outlined, color: white, size: 16),
                                8.width,
                                Text('${count.validate()}', style: secondaryTextStyle(color: Colors.white)),
                              ],
                            ).onTap(() {
                              likeDislike(widget.newsData!.iD.validate());
                              setState(() {});
                            })
                          ],
                        ).paddingOnly(left: 8, right: 8, top: 8, bottom: 8),
                      ],
                    ),
                    // HtmlWidget(postContent: widget.postContent, color: Colors.white),
                    30.height,
                    AppButton(
                      text: appLocalization.translate('view_Comments'),
                      color: appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimary,
                      textStyle: boldTextStyle(color: white),
                      onTap: () async {
                        await CommentListScreen(widget.newsData!.iD).launch(context);
                        await Future.delayed(Duration(milliseconds: 300));

                        setDynamicStatusBarColorDetail(milliseconds: 400);
                      },
                      width: context.width(),
                    ).paddingSymmetric(horizontal: 16).visible(widget.newsData!.comment_count.validate().isNotEmpty),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                          margin: EdgeInsets.only(left: 16, top: 32, bottom: 8),
                          decoration: BoxDecoration(color: colorPrimary, borderRadius: radius(defaultRadius)),
                          child: Text(appLocalization.translate('related_news'), style: boldTextStyle(size: 12, color: Colors.white, letterSpacing: 1.5)),
                        ),
                        BreakingNewsListWidget(widget.relatedNews.validate()),
                      ],
                    ).visible(widget.relatedNews.validate().isNotEmpty),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
