import 'package:async/async.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:live_uttarpradesh/provider/home_provider.dart';
import 'package:live_uttarpradesh/provider/live_tv_provider.dart';
import 'package:provider/provider.dart';
import '../../../AppLocalizations.dart';
import '../../../AppTheme.dart';
import '../../../models/FontSizeModel.dart';
import '../../../screens/SplashScreen.dart';
import '../../../store/AppStore.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'models/LanguageModel.dart';
import 'models/WeatherResponse.dart';

AppStore appStore = AppStore();

int mAdShowCount = 0;

Language? language;
List<Language> languages = Language.getLanguages();

FontSizeModel? fontSize;
List<FontSizeModel> fontSizes = FontSizeModel.fontSizes();

Language? ttsLang;
List<Language> ttsLanguage = Language.getLanguagesForTTS();

var weatherMemoizer = AsyncMemoizer<WeatherResponse>();

FirebaseRemoteConfig? remoteConfig;
int retryCount = 0;

AppLocalizations? appLocale;

void main() async {
   await WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();

  defaultRadius = 10;
  defaultAppButtonRadius = 30;
  defaultBlurRadius = 4.0;

   await initialize(defaultDialogBorderRadius: 10);
  appStore.setLanguage(getStringAsync(LANGUAGE, defaultValue: defaultLanguage));
  appStore.setNotification(getBoolAsync(IS_NOTIFICATION_ON, defaultValue: true));
  appStore.setTTSLanguage(getStringAsync(TEXT_TO_SPEECH_LANG, defaultValue: defaultTTSLanguage));

  ///Uncomment below line if you want to skip https certificate
  //HttpOverrides.global = HttpOverridesSkipCertificate();

  int themeModeIndex = getIntAsync(THEME_MODE_INDEX);
  if (themeModeIndex == ThemeModeLight) {
    await appStore.setDarkMode(false);
  } else if (themeModeIndex == ThemeModeDark) {
    await appStore.setDarkMode(true);
  }

  fontSize = fontSizes.firstWhere((element) => element.fontSize == getIntAsync(FONT_SIZE_PREF, defaultValue: 16));
  ttsLang = ttsLanguage.firstWhere((element) => element.fullLanguageCode == getStringAsync(TEXT_TO_SPEECH_LANG, defaultValue: defaultTTSLanguage));

  if (isMobile) {

    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.Debug.setAlertLevel(OSLogLevel.none);
    OneSignal.consentRequired(false);
    OneSignal.initialize(mOneSignalAPPKey);
    OneSignal.User.pushSubscription.optIn();
    OneSignal.Notifications.permission;
    // await OneSignal.shared.setAppId(mOneSignalAPPKey);
    // OneSignal.shared.consentGranted(true);
    // OneSignal.shared.promptUserForPushNotificationPermission();
    // OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
  }

  setOrientationPortrait();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomeProvider()),
          ChangeNotifierProvider(create: (_) => LiveTvProvider()),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: mAppName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          supportedLocales: Language.languagesLocale(),
          localizationsDelegates: [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
          localeResolutionCallback: (locale, supportedLocales) => locale,
          locale: Locale(appStore.selectedLanguageCode),
          home: SplashScreen(),
          scrollBehavior: SBehavior(),
        ),
      ),
    );
  }
}


