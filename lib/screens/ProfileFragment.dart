import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../AppLocalizations.dart';

import '../screens/AboutAppScreen.dart';

import '../../../utils/extension.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:live_uttarpradesh/components/AppWidgets.dart';
import 'package:live_uttarpradesh/main.dart';
import 'package:live_uttarpradesh/utils/app_images.dart';
import 'package:live_uttarpradesh/screens/DashboardScreen.dart';

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
    return WillPopScope(
      onWillPop: () async {
        setDynamicStatusBarColor(color: Colors.transparent);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            AppImages.appLogo,
            fit: BoxFit.fitHeight,
            width: 80,
          ),
          actions: [
            IconButton(
              onPressed: () {
                LiveStream().emit(switchLiveTvTab, true);
              },
              icon: Icon(Icons.live_tv, color: Colors.white),
              tooltip: "Live TV",
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Content
              16.height,
              _buildSectionHeader(context, "General"),
              _buildSectionCard(context, [
                _buildSettingItem(
                  icon: Icons.home_outlined,
                  title: "Home",
                  onTap: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashboardScreen()), (route) => false),
                ),
                _buildSettingItem(
                  icon: Icons.info_outline,
                  title: "About Us",
                  onTap: () => AboutAppScreen().launch(context),
                ),
              ]),
              16.height,
              _buildSectionHeader(context, "App Settings"),
              _buildSectionCard(context, [
                Observer(
                  builder: (_) => _buildSettingItem(
                    icon: appStore.isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                    title: appStore.isDarkMode ? "Dark Mode" : "Light Mode",
                    trailing: CupertinoSwitch(
                      value: appStore.isDarkMode,
                      onChanged: (v) => appStore.setDarkMode(v),
                      activeColor: context.primaryColor,
                    ),
                    onTap: () => appStore.setDarkMode(!appStore.isDarkMode),
                  ),
                ),
              ]),
              16.height,
              _buildSectionHeader(context, "Information"),
              _buildSectionCard(context, [
                _buildSettingItem(
                  icon: Icons.security_outlined,
                  title: "Privacy Policy",
                  onTap: () => launchUrl(Uri.parse('https://aajkikhabar.com/privacy-policy/'), mode: LaunchMode.externalApplication),
                ),
                _buildSettingItem(
                  icon: Icons.description_outlined,
                  title: "Terms & Conditions",
                  onTap: () => launchUrl(Uri.parse('https://aajkikhabar.com/terms-conditions/'), mode: LaunchMode.externalApplication),
                ),
              ]),
              16.height,
              _buildSectionHeader(context, "Support & Social"),
              _buildSectionCard(context, [
                _buildSettingItem(
                  icon: Icons.phone_outlined,
                  title: "Contact Us",
                  onTap: () => launchUrl(Uri.parse('https://aajkikhabar.com/contact-us/'), mode: LaunchMode.externalApplication),
                ),
                _buildSettingItem(
                  icon: Icons.share_outlined,
                  title: "Share App",
                  onTap: () {
                    PackageInfo.fromPlatform().then((value) {
                      Share.share('Check out $mAppName app\n\n${storeBaseURL()}${isAndroid ? value.packageName : ""}');
                    });
                  },
                ),
              ]),
              30.height,
              Center(
                child: Column(
                  children: [
                    Opacity(
                      opacity: 0.5,
                      child: Image.asset(AppImages.appLogo, width: 60, height: 60, fit: BoxFit.contain),
                    ),
                    8.height,
                    Text("Version 1.0.0", style: secondaryTextStyle(size: 12)),
                  ],
                ),
              ),
              50.height,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(title.toUpperCase(), style: boldTextStyle(size: 13, color: context.primaryColor, letterSpacing: 1.2)),
    );
  }

  Widget _buildSectionCard(BuildContext context, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingItem({required IconData icon, required String title, Widget? trailing, required VoidCallback onTap}) {
    return SettingItemWidget(
      leading: Icon(icon, color: context.iconColor.withOpacity(0.7)),
      title: title,
      titleTextStyle: primaryTextStyle(size: 15),
      trailing: trailing ?? Icon(Icons.chevron_right, color: Colors.grey.withOpacity(0.5)),
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
