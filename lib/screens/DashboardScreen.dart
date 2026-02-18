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
import '../widget/custom_icon_button.dart';
import 'live_tv_view.dart';

class DashboardScreen extends StatefulWidget {
  static String tag = '/DashboardScreen';

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  List<Widget> widgets = [];
  int currentIndex = 1;
  bool isFullScreen = false;

  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setDynamicStatusBarColor(color: Colors.transparent);
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
      currentIndex = 1;
      setState(() {});
    });
    LiveStream().on(tokenStream, (v) {
      LoginScreen(isNewTask: false).launch(context);
    });
    LiveStream().on(isFullScreenApp, (v) {
      isFullScreen = v as bool;
      setState(() {});
    });
    LiveStream().on(switchLiveTvTab, (v) {
      currentIndex = 1;
      setState(() {});
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
    LiveStream().dispose(isFullScreenApp);
    LiveStream().dispose(switchLiveTvTab);

    window.onPlatformBrightnessChanged = null;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void _onTabChanged(int index) {
    if (currentIndex == index) return;
    currentIndex = index;
    if (index == 1) {
      LiveStream().emit(playPauseLiveTv, true);
    } else {
      LiveStream().emit(playPauseLiveTv, false);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: WillPopScope(
        onWillPop: () async {
          setDynamicStatusBarColor(color: Colors.transparent);

          DateTime now = DateTime.now();
          if (currentIndex == 1) {
            if (currentBackPressTime == null || now.difference(currentBackPressTime!) > 2.seconds) {
              currentBackPressTime = now;
              toast(AppLocalizations.of(context)!.translate('exit_app'));
              return Future.value(false);
            }
          } else {
            currentIndex = 1;
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
          bottomNavigationBar: isFullScreen ? null : Observer(
            builder: (_) => Container(
              height: 70 + (context.navigationBarHeight > 0 ? 10 : 0),
              padding: EdgeInsets.only(bottom: context.navigationBarHeight > 0 ? 15 : 5),
              decoration: BoxDecoration(
                color: context.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                   CustomIconButton(
                    activeIconData: Icons.home,
                    inactiveIconData: Icons.home_outlined,
                    isActive: currentIndex == 0,
                    onTap: () => _onTabChanged(0),
                    activeColor: AppColors.redColor,
                    inactiveColor: Colors.grey,
                  ),
                   GestureDetector(
                    onTap: () => _onTabChanged(1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: currentIndex == 1 ? Border.all(color: AppColors.redColor, width: 2) : null,
                      ),
                      child: CustomIconButton(
                        activeIconData: Icons.video_library,
                        inactiveIconData: Icons.video_library_outlined,
                        isActive: currentIndex == 1,
                        onTap: () => _onTabChanged(1),
                        activeColor: AppColors.redColor,
                        inactiveColor: Colors.grey,
                        activeSize: 32,
                      ),
                    ),
                  ),
                  _buildProfileTab(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    bool isActive = currentIndex == 2;
    return GestureDetector(
      onTap: () => _onTabChanged(2),
      child: Container(
        padding: const EdgeInsets.all(2),
        child: appStore.isLoggedIn
            ? cachedImage(
                appStore.userProfileImage,
                height: isActive ? 34 : 28,
                width: isActive ? 34 : 28,
                fit: BoxFit.cover,
              ).cornerRadiusWithClipRRect(20)
             : CustomIconButton(
                activeIconData: Icons.person,
                inactiveIconData: Icons.person_outline,
                isActive: isActive,
                onTap: () => _onTabChanged(2),
                activeColor: AppColors.redColor,
                inactiveColor: Colors.grey,
              ),
      ),
    );
  }
}
