import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../components/ReadAloudDialog.dart';
import '../../../utils/extension.dart';
import 'package:nb_utils/nb_utils.dart';

class ReadAloudScreen extends StatefulWidget {
  final String text;

  ReadAloudScreen(this.text);

  @override
  _ReadAloudScreenState createState() => _ReadAloudScreenState();
}

class _ReadAloudScreenState extends State<ReadAloudScreen> {
  RewardedAd? rewardedAd;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    if (adEnableOnPlay && isEnableAds) {
      showAdMobRewardedAd();
    }
    setDynamicStatusBarColorDetail(milliseconds: 400);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  void adMobRewardedAd() {
    RewardedAd.load(
        adUnitId: getRewardAdUnitId()!,
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            rewardedAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            rewardedAd = null;
            adMobRewardedAd();
          },
        ));
  }

  void showAdMobRewardedAd() {
    if (rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) => print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        toast('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        // adMobRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        toast('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        adMobRewardedAd();
      },
    );

    rewardedAd!.setImmersiveMode(true);

    rewardedAd!.show(onUserEarnedReward: ( AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
    });
    rewardedAd = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        'Read Aloud',
        color: getAppBarWidgetBackGroundColor(),
        textColor: getAppBarWidgetTextColor(),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: true,
            automaticallyImplyLeading: false,
            expandedHeight: 200.0,
            flexibleSpace: ReadAloudDialog(widget.text),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              return Text(widget.text, style: primaryTextStyle()).paddingOnly(top: 24, right: 16, left: 16, bottom: 16);
            }, childCount: 1),
          ),
        ],
      ),
    );
  }
}
