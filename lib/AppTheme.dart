import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_uttarpradesh/utils/app_colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'main.dart';

class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    primarySwatch: createMaterialColor(AppColors.primaryColor),
    primaryColor: AppColors.primaryColor,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
    ),
    scaffoldBackgroundColor: AppColors.whiteColor,
    fontFamily: GoogleFonts.roboto().fontFamily,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: AppColors.whiteColor),
    iconTheme: IconThemeData(color: AppColors.scaffoldSecondaryDark),
    textTheme: GoogleFonts.robotoTextTheme().apply(
      displayColor: AppColors.textColor,
      bodyColor: AppColors.textColor,
    ),
    dialogBackgroundColor: AppColors.whiteColor,
    unselectedWidgetColor: AppColors.blackColor,
    dividerColor: viewLineColor,
    cardColor: AppColors.whiteColor,
    dialogTheme: DialogThemeData(shape: dialogShape(), backgroundColor: AppColors.whiteColor),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.primaryColor,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
  ).copyWith(
    scrollbarTheme: ScrollbarThemeData(),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primarySwatch: createMaterialColor(AppColors.primaryColor),
    primaryColor: AppColors.primaryColor,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
    ),
    scaffoldBackgroundColor: AppColors.scaffoldColorDark,
    fontFamily: GoogleFonts.roboto().fontFamily,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: AppColors.scaffoldSecondaryDark),
    iconTheme: IconThemeData(color: AppColors.whiteColor),
    textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme).apply(
      displayColor: AppColors.whiteColor,
      bodyColor: Colors.white70,
    ),
    dialogBackgroundColor: AppColors.scaffoldSecondaryDark,
    unselectedWidgetColor: Colors.white60,
    dividerColor: Colors.white12,
    cardColor: AppColors.scaffoldSecondaryDark,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.primaryColor,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    dialogTheme: DialogThemeData(shape: dialogShape(), backgroundColor: AppColors.scaffoldSecondaryDark),
  ).copyWith(
    scrollbarTheme: ScrollbarThemeData(),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
