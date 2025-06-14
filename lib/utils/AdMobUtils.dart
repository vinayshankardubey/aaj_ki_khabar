import 'dart:io';
import 'AdConfigurationConstants.dart';

String? getBannerAdUnitId() {
  if (Platform.isIOS) {
    return AD_MOB_BANNER_ID_IOS;
  } else if (Platform.isAndroid) {
    return AD_MOB_BANNER_ID;
  }
  return null;
}

String? getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return AD_MOB_INTERSTITIAL_ID_IOS;
  } else if (Platform.isAndroid) {
    return AD_MOB_INTERSTITIAL_ID;
  }
  return null;
}

String? getRewardAdUnitId() {
  if (Platform.isAndroid) {
    return AD_MOB_REWARD_ID;
  } else if (Platform.isIOS) {
    return AD_MOB_REWARD_ID_IOS;
  }
  return null;
}

String? getOpenAppAdUnitId() {
  if (Platform.isIOS) {
    return AD_MOB_OPEN_AD_ID_IOS;
  } else if (Platform.isAndroid) {
    return AD_MOB_OPEN_AD_ID;
  }
  return null;
}

