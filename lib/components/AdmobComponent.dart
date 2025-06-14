import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../utils/AdMobUtils.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/AdConfigurationConstants.dart';

RewardedAd? rewardedAd;
InterstitialAd? myInterstitial;

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

Future<void> loadInterstitialAd() async {
  if(isInterstitialAdsEnable==true && isEnableAds==true)
  InterstitialAd.load(
    adUnitId: getInterstitialAdUnitId()!,
    request: AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (InterstitialAd ad) {
        myInterstitial = ad;
      },
      onAdFailedToLoad: (LoadAdError error) {
        myInterstitial = null;
      },
    ),
  );
}

Future<void> showInterstitialAd() async {
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

void adMobRewardedAd() {
  RewardedAd.load(
      adUnitId: getRewardAdUnitId()! ,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          log('$ad loaded.');
          rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          log('RewardedAd failed to load');
          rewardedAd = null;
          // adMobRewardedAd();
        },
      ));
}

void showAdMobRewardedAd({Function? onCall}) {
  if (rewardedAd == null) {
    onCall!();
    return;
  }
  rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (RewardedAd ad) => print('ad onAdShowedFullScreenContent.'),
    onAdDismissedFullScreenContent: (RewardedAd ad) {
      print('onAdDismissedFullScreenContent.');
      ad.dispose();
      onCall!();
      // adMobRewardedAd();
    },
    onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
      print('onAdFailedToShowFullScreenContent: $error');
      ad.dispose();
      adMobRewardedAd();
      // onCall!();
    },
  );

  rewardedAd!.setImmersiveMode(true);

  rewardedAd!.show(onUserEarnedReward: ( AdWithoutView ad, RewardItem reward) {
    toast('$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
  });
  rewardedAd = null;
}
