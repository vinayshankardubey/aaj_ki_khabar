import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import 'package:nb_utils/nb_utils.dart';

import 'main.dart';

class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    primarySwatch: createMaterialColor(AppColors.blackColor),
    primaryColor: AppColors.whiteColor,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: GoogleFonts.roboto().fontFamily,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.white),
    iconTheme: IconThemeData(color: AppColors.scaffoldSecondaryDark),
    textTheme: TextTheme(titleLarge: TextStyle()),
    dialogBackgroundColor: Colors.white,
    unselectedWidgetColor: Colors.black,
    dividerColor: viewLineColor,
    cardColor: Colors.white,
    appBarTheme: appStore.appBarTheme,
    dialogTheme: DialogTheme(shape: dialogShape(), backgroundColor: Colors.white),
  ).copyWith(
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primarySwatch: createMaterialColor(AppColors.whiteColor),
    primaryColor: AppColors.whiteColor,
    scaffoldBackgroundColor: AppColors.scaffoldColorDark,
    fontFamily: GoogleFonts.roboto().fontFamily,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: AppColors.scaffoldSecondaryDark),
    iconTheme: IconThemeData(color: Colors.white),
    textTheme: TextTheme(titleLarge: TextStyle(color: textSecondaryColor)),
    dialogBackgroundColor: AppColors.scaffoldSecondaryDark,
    unselectedWidgetColor: Colors.white60,
    dividerColor: Colors.white12,
    cardColor: AppColors.scaffoldSecondaryDark,
    appBarTheme: appStore.appBarTheme,
    dialogTheme: DialogTheme(shape: dialogShape(), backgroundColor: AppColors.scaffoldSecondaryDark),
  ).copyWith(
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
