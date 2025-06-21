import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:live_uttarakhand/screens/home_screen.dart';
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
import 'category_screen.dart';

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
    setDynamicStatusBarColor();
    setValue(banner, mDisplayBanner);
    setValue(interstitial, mDisplayInterstitial);
    setValue(reward, mDisplayReward);
    setValue(native, mDisplayNative);

    widgets.add(HomeScreen());
    // widgets.add(SuggestedForYouFragment());
    widgets.add(CategoryScreen());
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
                  icon: Icon(AntDesign.home, color: context.theme.iconTheme.color),
                  label: 'Home',
                  activeIcon: Icon(AntDesign.home, color: AppColors.redColor),
                ),
                // BottomNavigationBarItem(
                //   icon: Icon(Icons.dashboard_outlined, color: context.theme.iconTheme.color),
                //   label: 'Suggested For You',
                //   activeIcon: Icon(Icons.dashboard_outlined, color: colorPrimary),
                // ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.category_outlined, color: context.theme.iconTheme.color),
                  label: 'Category',
                  activeIcon: Icon(Icons.category_outlined, color: AppColors.redColor),
                ),
                // BottomNavigationBarItem(
                //   icon: Icon(Ionicons.ios_search, color: context.theme.iconTheme.color),
                //   label: 'Search News',
                //   activeIcon: Icon(Ionicons.ios_search, color: colorPrimary),
                // ),
                BottomNavigationBarItem(
                  icon: appStore.isLoggedIn
                      ? cachedImage(appStore.userProfileImage, height: 24, width: 24, fit: BoxFit.cover).cornerRadiusWithClipRRect(15)
                      : Icon(MaterialIcons.person_outline, color: context.theme.iconTheme.color),
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
                      : Icon(MaterialIcons.person_outline, color: AppColors.redColor),
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
