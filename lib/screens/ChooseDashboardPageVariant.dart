import 'package:flutter/material.dart';
import '../AppLocalizations.dart';
import '../network/RestApis.dart';
import '../screens/DashboardScreen.dart';
import '../../../utils/extension.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class ChooseDashboardPageVariant extends StatefulWidget {
  static String tag = '/ChooseDashboardScreen';

  @override
  ChooseDashboardPageVariantState createState() => ChooseDashboardPageVariantState();
}

class ChooseDashboardPageVariantState extends State<ChooseDashboardPageVariant> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setDynamicStatusBarColor();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocale = AppLocalizations.of(context)!;

    return SafeArea(
      top: !isIOS ? true : false,
      child: Scaffold(
        appBar: appBarWidget(
          appLocale.translate('choose_dashboard_page_variant'),
          showBack: true,
          elevation: 0,
          color: getAppBarWidgetBackGroundColor(),
          textColor: getAppBarWidgetTextColor(),
          actions: [
            IconButton(
              icon: Icon(Icons.home_outlined, color: getAppBarWidgetBackGroundColor().isDark() ? Colors.white : Colors.black),
              onPressed: () {
                DashboardScreen().launch(context, isNewTask: true);
              },
            ),
          ],
        ),
        body: Container(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Wrap(
              runSpacing: 8,
              spacing: 8,
              children: [
                itemWidget(
                  title: '${appLocale.translate('variant')} 1',
                  code: 1,
                  onTap: () {
                    _selectVariant(1, appLocale);
                  },
                ),
                itemWidget(
                  title: '${appLocale.translate('variant')} 2',
                  code: 2,
                  onTap: () {
                    _selectVariant(2, appLocale);
                  },
                ),
                itemWidget(
                  title: '${appLocale.translate('variant')} 3',
                  code: 3,
                  onTap: () {
                    _selectVariant(3, appLocale);
                  },
                ),
              ],
            ).center(),
          ),
        ),
      ),
    );
  }

  void _selectVariant(int code, AppLocalizations appLocale) async {
    if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) != code) {
      setValue(DASHBOARD_PAGE_VARIANT, code);
      setState(() {});
      DashboardScreen().launch(context, isNewTask: true);
    }
  }

  Widget itemWidget({required Function onTap, String? title, int code = 1, String? img}) {
    return Container(
      width: context.width() * 0.48,
      height: context.height() * 0.4,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == code ? colorPrimary : Theme.of(context).dividerColor,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/dashBoard_variant_$code.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 800),
            color: getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == code ? Colors.black12 : Colors.black45,
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 800),
            child: Text(title.validate(), style: boldTextStyle(color: textPrimaryColor)),
            decoration: BoxDecoration(color: getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == code ? Colors.white : Colors.white54, borderRadius: radius(defaultRadius)),
            padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          ).center(),
          Positioned(
            bottom: 8,
            right: 8,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 800),
              padding: EdgeInsets.all(4),
              child: Icon(Icons.check, size: 18, color: colorPrimary),
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: defaultBoxShadow()),
            ).visible(getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: defaultDashboardPage) == code),
          ),
        ],
      ),
    ).onTap(() {
      onTap.call();

      setDynamicStatusBarColor();
      if (appStore.isLoggedIn) {
        updateProfile(showToast: false).then((value) {
          //
        }).catchError((e) {
          log(e);
        });
      }
    });
  }
}
