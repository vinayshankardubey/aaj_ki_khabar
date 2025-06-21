import 'package:flutter/material.dart';
import '../../../AppLocalizations.dart';
import '../../../network/RestApis.dart';
import '../../../utils/extension.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class ForgotPasswordDialog extends StatefulWidget {
  static String tag = '/ForgotPasswordDialog';

  @override
  ForgotPasswordDialogState createState() => ForgotPasswordDialogState();
}

class ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  TextEditingController emailCont = TextEditingController();

  Future<void> submit(AppLocalizations appLocale) async {
    if (emailCont.text.trim().isEmpty) return toast(errorThisFieldRequired);

    if (!emailCont.text.trim().validateEmail()) return toast(appLocale.translate('email_is_invalid'));

    hideKeyboard(context);

    Map req = {
      'email': emailCont.text.trim(),
    };

    await forgotPassword(req).then((value) {
      toast(value.message);
      finish(context);
    }).catchError((e) {
      toast(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return Container(
      width: context.width(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(appLocalization.translate('forgot_pwd'), style: boldTextStyle()),
              CloseButton(),
            ],
          ),
          8.height,
          AppTextField(
            controller: emailCont,
            textFieldType: TextFieldType.EMAIL,
            decoration: inputDecoration(context, hint: appLocalization.translate('email')),
            textStyle: primaryTextStyle(),
            autoFocus: true,
          ),
          30.height,
          AppButton(
            text: appLocalization.translate('submit'),
            color: appStore.isDarkMode ? AppColors.scaffoldSecondaryDark : AppColors.redColor,
            textStyle: boldTextStyle(color: white),
            onTap: () {
              submit(appLocalization);
            },
            width: context.width(),
          ),
        ],
      ),
    );
  }
}
