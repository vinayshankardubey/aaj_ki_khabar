import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:live_uttarpradesh/screens/home_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../AppLocalizations.dart';
import '../../../components/AppWidgets.dart';
import '../../../main.dart';
import '../screens/LoginScreen.dart';
import '../screens/NewsDetailScreen.dart';
import '../screens/ProfileFragment.dart';
import '../../../utils/extension.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'live_tv_view.dart';

class DashboardScreen extends StatefulWidget {
  static String tag = '/DashboardScreen';

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  List<Widget> widgets = [];
  int currentIndex = 0;

  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setDynamicStatusBarColor(color: AppColors.redColor);
    setValue(banner, mDisplayBanner);
    setValue(interstitial, mDisplayInterstitial);
    setValue(reward, mDisplayReward);
    setValue(native, mDisplayNative);

    widgets.add(HomeScreen());
    // widgets.add(SuggestedForYouFragment());
    widgets.add(LiveTvScreen());
    // widgets.add(SearchNewsFragment());
    widgets.add(ProfileFragment());

    setState(() {});

    LiveStream().on(checkMyTopics, (v) {
      currentIndex = 0;
      setState(() {});
    });
    LiveStream().on(tokenStream, (v) {
      LoginScreen(isNewTask: false).launch(context);
    });

    await Future.delayed(Duration(milliseconds: 400));

    if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) {
      appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.dark);
    }

    window.onPlatformBrightnessChanged = () async {
      if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) {
        appStore.setDarkMode(context.platformBrightness() == Brightness.light);
      }
    };

    afterBuildCreated(() {
      appLocale = AppLocalizations.of(context);
      appStore.setLanguage(appStore.selectedLanguageCode, context: context);

      if (isMobile) {

        OneSignal.Notifications.addClickListener((_handleNotificationOpened) async {
        // OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult notification) async {
          if (_handleNotificationOpened.notification.additionalData!.containsKey('ID')) {
            String? notId = _handleNotificationOpened.notification.additionalData!["ID"];

            if (notId.validate().isNotEmpty) {
              String heroTag = '$notId${currentTimeStamp()}';

              NewsDetailScreen(id: notId.toString(), heroTag: heroTag, disableAd: false).launch(context);
            }
          }
        });
      }

      if (isAndroid) {
        PackageInfo.fromPlatform().then((value) {
          checkForceUpdateForAndroid(currentVersion: value.buildNumber.toInt(), forceUpdateVersion: getIntAsync(FORCE_UPDATE_VERSION_CODE), packageName: value.packageName);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    LiveStream().dispose(checkMyTopics);
    LiveStream().dispose(tokenStream);

    window.onPlatformBrightnessChanged = null;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          setDynamicStatusBarColor(color: AppColors.redColor);

          DateTime now = DateTime.now();
          if (currentIndex == 0) {
            if (currentBackPressTime == null || now.difference(currentBackPressTime!) > 2.seconds) {
              currentBackPressTime = now;
              toast(AppLocalizations.of(context)!.translate('exit_app'));
              return Future.value(false);
            }
          } else {
            currentIndex = 0;
            setState(() {});
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: Scaffold(
          body: IndexedStack(
            children: widgets,
            index: currentIndex,
          ),
          bottomNavigationBar: Observer(
            builder: (_) => BottomNavigationBar(
              backgroundColor: AppColors.backgroundColor,
              currentIndex: currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: context.theme.iconTheme.color,size: 28,),
                  label: 'Home',
                  activeIcon: Icon(Icons.home_outlined, color: AppColors.redColor,size: 28),
                ),
                // BottomNavigationBarItem(
                //   icon: Icon(Icons.dashboard_outlined, color: context.theme.iconTheme.color),
                //   label: 'Suggested For You',
                //   activeIcon: Icon(Icons.dashboard_outlined, color: colorPrimary),
                // ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.live_tv, color: context.theme.iconTheme.color,size: 28,),
                  label: 'Live Tv',
                  activeIcon: Icon(Icons.live_tv_outlined, color: AppColors.redColor,size: 28,),
                ),
                // BottomNavigationBarItem(
                //   icon: Icon(Ionicons.ios_search, color: context.theme.iconTheme.color),
                //   label: 'Search News',
                //   activeIcon: Icon(Ionicons.ios_search, color: colorPrimary),
                // ),
                BottomNavigationBarItem(
                  icon: appStore.isLoggedIn
                      ? cachedImage(appStore.userProfileImage, height: 24, width: 24, fit: BoxFit.cover).cornerRadiusWithClipRRect(15)
                      : Icon(Icons.person, color: context.theme.iconTheme.color,size: 28,),
                  label: 'Profile',
                  activeIcon: appStore.isLoggedIn
                      ? Container(
                          decoration: BoxDecoration(border: Border.all(color: AppColors.grayColor), shape: BoxShape.circle),
                          child: cachedImage(
                            appStore.userProfileImage,
                            height: 24,
                            width: 24,
                            fit: BoxFit.cover,
                          ).cornerRadiusWithClipRRect(15))
                      : Icon(Icons.person, color: AppColors.redColor,size: 28,),
                ),
              ],
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              onTap: (i) async {
                // if (i == 1) {
                //   if (!appStore.isLoggedIn) {
                //     LoginScreen().launch(context);
                //   } else if (appStore.myTopics.isEmpty && i == 1) {
                //     await ChooseTopicScreen().launch(context);
                //
                //     if (appStore.myTopics.isNotEmpty) {
                //       currentIndex = 1;
                //     }
                //   } else {
                //     currentIndex = i;
                //   }
                // } else {
                //   currentIndex = i;
                // }
                currentIndex = i;

                setState(() {});
              },
            ),
          ),
        ),
      ),
    );
  }
}
