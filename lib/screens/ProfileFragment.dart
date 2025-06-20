import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aaj_ki_khabar/screens/privacy_policy_screen.dart';
import 'package:aaj_ki_khabar/screens/terms_and_condition.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../AppLocalizations.dart';

import '../screens/AboutAppScreen.dart';

import '../../../utils/extension.dart';
import 'package:nb_utils/nb_utils.dart';

import 'DashboardScreen.dart';

class ProfileFragment extends StatefulWidget {
  static String tag = '/ProfileFragment';

  @override
  ProfileFragmentState createState() => ProfileFragmentState();
}

class ProfileFragmentState extends State<ProfileFragment> {

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
        toolbarHeight: 64,
        title: Image.asset("assets/images/app_image.png",
          fit: BoxFit.fitHeight,
          height: 50,
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: context.statusBarHeight),
        child: Column(
        children: [
        SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

        // Container(
        //   padding: EdgeInsets.all(16),
        //   color: appStore.isDarkMode ? scaffoldSecondaryDark : Colors.white,
        //   child: appStore.isLoggedIn
        //       ? Row(
        //           children: [
        //             appStore.userProfileImage.validate().isEmpty
        //                 ? Icon(Icons.person_outline, size: 40)
        //                 : cachedImage(appStore.userProfileImage.validate(), usePlaceholderIfUrlEmpty: true, height: 60, width: 60, fit: BoxFit.cover).cornerRadiusWithClipRRect(60),
        //             16.width,
        //             Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Text('${appStore.userFirstName.validate()} ${appStore.userLastName.validate()}', style: boldTextStyle()),
        //                 Text(appStore.userEmail.validate(), style: primaryTextStyle()).fit(),
        //               ],
        //             ).expand(),
        //             IconButton(
        //               icon: Icon(Icons.edit),
        //               onPressed: () => EditProfileScreen().launch(context),
        //             ),
        //           ],
        //         )
        //       : Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Container(
        //               padding: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
        //               decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor)),
        //               child: Text(appLocalization!.translate('login'), style: boldTextStyle()),
        //             ).onTap(() async {
        //               await LoginScreen(isNewTask: false).launch(context);
        //               setState(() {});
        //             }),
        //             if (enableSocialLogin) SocialLoginWidget(voidCallback: () => setState(() {})),
        //           ],
        //         ),
        // ),
        // Divider(height: 20, color: appStore.isDarkMode ? Colors.transparent : Theme.of(context).dividerColor),
        // 8.height,

        // LanguageSelectionWidget(),
        // SettingItemWidget(
        //   leading: Icon(MaterialCommunityIcons.theme_light_dark),
        //   title: '${appLocalization.translate('select_theme')}',
        //   subTitle: appLocalization.translate('choose_app_theme'),
        //   onTap: () async {
        //     await showInDialog(
        //       context,
        //       builder: (context) => ThemeSelectionDialog(),
        //       contentPadding: EdgeInsets.zero,
        //       title: Text(appLocalization.translate('select_theme'), style: boldTextStyle(size: 20)),
        //     );
        //     if (isIOS) {
        //       DashboardScreen().launch(context, isNewTask: true);
        //     }
        //   },
        // ),
        // 8.height,
        // SettingItemWidget(
        //   leading: Icon(appStore.isNotificationOn ? Feather.bell : Feather.bell_off),
        //   title: '${appStore.isNotificationOn ? appLocalization.translate('disable') : appLocalization.translate('enable')} ${appLocalization.translate(
        //     'push_notification',
        //   )}',
        //   subTitle: appLocalization.translate('enable_push_notification'),
        //   trailing: CupertinoSwitch(
        //     activeColor: colorPrimary,
        //     value: appStore.isNotificationOn,
        //     onChanged: (v) {
        //       appStore.setNotification(v);
        //     },
        //   ).withHeight(10),
        //   onTap: () {
        //     appStore.setNotification(!getBoolAsync(IS_NOTIFICATION_ON, defaultValue: true));
        //   },
        // ),
        // SettingItemWidget(
        //   leading: Icon(FontAwesome.font),
        //   title: appLocalization.translate('article_font_size'),
        //   subTitle: appLocalization.translate('choose_article_size'),
        //   trailing: DropdownButton<FontSizeModel>(
        //     items: fontSizes.map((e) {
        //       return DropdownMenuItem<FontSizeModel>(child: Text('${e.title}', style: primaryTextStyle(size: 14)), value: e);
        //     }).toList(),
        //     dropdownColor: appStore.isDarkMode ? scaffoldSecondaryDark : Colors.white,
        //     value: fontSize,
        //     underline: SizedBox(),
        //     onChanged: (FontSizeModel? v) async {
        //       hideKeyboard(context);
        //
        //       await setValue(FONT_SIZE_PREF, v!.fontSize);
        //
        //       fontSize = fontSizes.firstWhere((element) => element.fontSize == getIntAsync(FONT_SIZE_PREF, defaultValue: 16));
        //
        //       setState(() {});
        //     },
        //   ),
        //   onTap: () {
        //     //
        //   },
        // ),
        // SettingItemWidget(
        //   leading: Image.asset('assets/tts.png', width: 25, height: 25, color: appStore.isDarkMode ? Colors.white : Colors.black),
        //   title: appLocalization.translate('text_to_speech'),
        //   subTitle: appLocalization.translate('select_tts_language'),
        //   trailing: DropdownButton<Language>(
        //     items: ttsLanguage.map((e) {
        //       return DropdownMenuItem<Language>(
        //         child: Text('${e.name}', style: primaryTextStyle(size: 14), overflow: TextOverflow.ellipsis),
        //         value: e,
        //       );
        //     }).toList(),
        //     dropdownColor: appStore.isDarkMode ? scaffoldSecondaryDark : Colors.white,
        //     value: ttsLang,
        //     underline: SizedBox(),
        //     onChanged: (Language? l) async {
        //       appStore.setTTSLanguage(l!.fullLanguageCode);
        //
        //       ttsLang = l;
        //
        //       setState(() {});
        //       toast('${l.name} ${appLocalization.translate('tts_language_confirm')}');
        //     },
        //   ),
        //   onTap: null,
        // ),
        // 16.height,
        // titleWidget(appLocalization.translate('other')),
        // 8.height,
        // SettingItemWidget(
        //   leading: Icon(Icons.lock_outline_rounded),
        //   title: appLocalization.translate('change_Pwd'),
        //   onTap: () {
        //     ChangePasswordScreen().launch(context);
        //   },
        // ).visible(appStore.isLoggedIn && !isLoggedInWithGoogleOrApple() && getStringAsync(LOGIN_TYPE) != LoginTypeOTP),
        // 8.height.visible(appStore.isLoggedIn && !isLoggedInWithGoogleOrApple() && getStringAsync(LOGIN_TYPE) != LoginTypeOTP),
        // SettingItemWidget(
        //   leading: Icon(Icons.my_library_add_outlined),
        //   title: appLocalization.translate('my_Topics'),
        //   onTap: () {
        //     if (appStore.isLoggedIn) {
        //       ChooseTopicScreen().launch(context);
        //     } else {
        //       LoginScreen().launch(context);
        //     }
        //   },
        // ),
          SettingItemWidget(
            leading: Icon(Icons.home),
            title: "Home",
            onTap: () {
             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> DashboardScreen()),  (Route<dynamic> route) => false,);
            },
          ),
          SettingItemWidget(
            leading: Icon(Icons.info_outline),
            title: "About us",
            onTap: () {
              AboutAppScreen().launch(context);
            },
          ),

          SettingItemWidget(
            leading: Icon(Icons.assignment_outlined),
            title: "Privacy Policy",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> PrivacyPolicyScreen()));
            },
          ),
          8.height,

        SettingItemWidget(
          leading: Icon(Icons.assignment_outlined),
          title: "Terms & Condition",
          onTap: () {
           Navigator.push(context, MaterialPageRoute(builder: (context)=> TermsAndConditionScreen()));
          },
        ),
        8.height,


        SettingItemWidget(
        leading: Icon(Icons.share_outlined),
        title: 'Share Aaj ki khabar ',
        onTap: () {
        PackageInfo.fromPlatform().then((value) {
        String package = '';
        if (isAndroid) package = value.packageName;

        Share.share('Share $mAppName app\n\n${storeBaseURL()}$package');
        });
        },
        ),

        8.height,
          SettingItemWidget(
        leading: Icon(Icons.phone),
        title: 'Contact us ',
        onTap: () async{
          String phoneNumber = '9696599965';
          final Uri uri = Uri(scheme: 'tel',path:'$phoneNumber');
          if (await canLaunchUrl(uri)) {
             await launchUrl(uri);
          } else {
          throw 'Could not launch $phoneNumber';
          }
        },
        ),
        8.height,


    /*SettingItemWidget(
                    leading: Icon(Icons.support_rounded),
                    title: appLocalization.translate('help_Support'),
                    onTap: () {
                      launchUrl(supportURL, forceWebView: true);
                    },
                  ),
                  8.height,*/

    // if (appStore.isLoggedIn)
    //   SettingItemWidget(
    //     title: appLocalization.translate('delete_account'),
    //     leading: Icon(AntDesign.delete,color: context.iconColor),
    //     onTap: () {
    //       showConfirmDialogCustom(
    //         context,
    //         customCenterWidget: SizedBox(),
    //         primaryColor: colorPrimary,
    //         title:
    //         appLocalization.translate('delete_account'),
    //         subTitle: appLocalization.translate("are_you_sure_you_want_to_delete_this_account"),
    //         positiveText:  appLocalization.translate('yes'),
    //         negativeText:  appLocalization.translate('no'),
    //         onAccept: (_) async {
    //           appStore.setLoading(true);
    //           deleteAccount().then((value) {
    //             toast(value.message);
    //             logout(context);
    //             appStore.setLoading(false);
    //             setValue(TOKEN, '');
    //             setState(() {});
    //           }).catchError((e) {
    //             toast(e.toString());
    //           });
    //         },
    //       );
    //     },
    //   ).paddingTop(8),
    // 8.height,
    // SettingItemWidget(
    //   leading: Icon(Icons.exit_to_app_rounded),
    //   title: appLocalization.translate('logout'),
    //   onTap: () async {
    //     bool? res = await showConfirmDialog(
    //       context,
    //       appLocalization.translate('logout_confirmation'),
    //       positiveText: appLocalization.translate('yes'),
    //       negativeText: appLocalization.translate('no'),
    //     );
    //
    //     if (res ?? false) {
    //       logout(context);
    //     }
    //   },
    // ).visible(appStore.isLoggedIn),
    // 8.height,
    // FutureBuilder<PackageInfo>(
    //   future: PackageInfo.fromPlatform(),
    //   builder: (_, snap) {
    //     if (snap.hasData) {
    //       return Text('${appLocalization.translate('version')} ${snap.data!.version.validate()}', style: secondaryTextStyle(size: 10)).paddingLeft(16);
    //     }
    //     return SizedBox();
    //   },
    // ),
    // 20.height,
    ],
    ),
    ),])
      ),
    );
  }
}
