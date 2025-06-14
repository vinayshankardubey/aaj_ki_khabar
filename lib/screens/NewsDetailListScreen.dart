import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
  BannerAd? myBanner;
  InterstitialAd? myInterstitial;
  PageController? pageController;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    print("News Detail Screen Navigating");
    pageController = PageController(initialPage: widget.index);

    if (isMobile) {
      myBanner = buildBannerAd()..load();
      if (isInterstitialAdsEnable == true && isEnableAds==true) {
        if (mAdShowCount < 5) {
          mAdShowCount++;
        } else {
          mAdShowCount = 0;
          loadInterstitialAd();
        }
      }
    }
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: getInterstitialAdUnitId()!,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('$ad loaded');
          myInterstitial = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error.');
          myInterstitial = null;
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (myInterstitial == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    myInterstitial!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        loadInterstitialAd();
      },
    );
    myInterstitial!.show();
    myInterstitial = null;
  }

  BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: getBannerAdUnitId()!,
      size: AdSize.banner,
      listener: BannerAdListener(onAdLoaded: (ad) {
        //
      }),
      request: AdRequest(),
    );
  }

  @override
  void dispose() {
    setDynamicStatusBarColor(milliseconds: 0);
    if (isInterstitialAdsEnable == true && isEnableAds==true) {
      showInterstitialAd();
    }
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
        if (isBannerAdsEnable == true && isEnableAds==true)
          if (myBanner != null)
            Positioned(
              child: Container(child: AdWidget(ad: myBanner!), color: Colors.white),
              bottom: 0,
              height: AdSize.banner.height.toDouble(),
              width: context.width(),
            ),
      ],
    );
  }
}
