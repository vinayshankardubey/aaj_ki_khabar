import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_uttarpradesh/screens/privacy_policy_screen.dart';
import 'package:live_uttarpradesh/screens/terms_and_condition.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../AppLocalizations.dart';

import '../screens/AboutAppScreen.dart';

import '../../../utils/extension.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/app_images.dart';
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
        backgroundColor: AppColors.redColor,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 64,
        title:  Image.asset(AppImages.appLogo,
          fit: BoxFit.fitHeight,
          width: 180,
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: context.statusBarHeight),
        child: Column(
        children: [
        SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


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
        title: 'Share Live UttarPradesh ',
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
    ],
    ),
    ),])
      ),
    );
  }
}
