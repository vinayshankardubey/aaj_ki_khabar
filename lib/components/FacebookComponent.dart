import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:facebook_audience_network/ad/ad_rewarded.dart';
import 'package:flutter/material.dart';
import '../utils/AdConfigurationConstants.dart';

bool isInterstitialAdLoaded = false;
bool isRewardedAdLoaded = false;
bool isRewardedAdLoadAds = false;

Widget currentAd = SizedBox(width: 0.0, height: 0.0);

void loadFaceBookInterstitialAd() {
  FacebookInterstitialAd.loadInterstitialAd(
    placementId: faceBookInterstitialPlacementId,
    listener: (result, value) {
      print(">> FAN > Interstitial Ad: $result --> $value");
      if (result == InterstitialAdResult.LOADED) {
        print(result.toString());
        isInterstitialAdLoaded = true;
      }
      if (result == InterstitialAdResult.DISMISSED && value["invalidated"] == true) {
        print(result.toString());
        isInterstitialAdLoaded = false;
      }
    },
  );
}

loadFaceBookRewardedVideoAd({required VoidCallback onCall}) {
  FacebookRewardedVideoAd.loadRewardedVideoAd(
    placementId: faceBookRewardPlacementId,
    listener: (result, value) async {
      if (result == RewardedVideoAdResult.LOADED) {
        print("load");
        isRewardedAdLoaded = true;
      }
      if (result == RewardedVideoAdResult.ERROR) {
        print("error");
        onCall.call();
      }
      if (result == RewardedVideoAdResult.VIDEO_CLOSED && (value == true || value["invalidated"] == true)) {
        print("Close");
        onCall();
        isRewardedAdLoaded = false;
        loadFaceBookRewardedVideoAd(onCall: (){
          onCall();
        });
      }
    },
  );
}

showFacebookInterstitialAd() {
  if (isInterstitialAdLoaded == true)
    FacebookInterstitialAd.showInterstitialAd();
  else
    print("Interstial Ad not yet loaded!");
}

showFacebookRewardedAd() {
  if (isRewardedAdLoaded == true)
    FacebookRewardedVideoAd.showRewardedVideoAd();
  else
    print("Rewarded Ad not yet loaded!");
}
