import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../AppLocalizations.dart';
import '../../../network/AuthService.dart';
import '../../../network/RestApis.dart';
import '../../../screens/DashboardScreen.dart';
import '../../../screens/RegisterScreen.dart';
import '../../../utils/extension.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:otp_text_field/otp_field.dart' as otp;
import 'package:otp_text_field/style.dart' as otpStyle;
import '../main.dart';

class OTPDialog extends StatefulWidget {
  static String tag = '/OTPDialog';
  final String? verificationId;
  final String? phoneNumber;
  final bool? isCodeSent;
  final PhoneAuthCredential? credential;

  OTPDialog({this.verificationId, this.isCodeSent, this.phoneNumber, this.credential});

  @override
  OTPDialogState createState() => OTPDialogState();
}

class OTPDialogState extends State<OTPDialog> {
  TextEditingController numberController = TextEditingController();

  String? countryCode = '';

  String otpCode = '';

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    appStore.setLoading(false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> submit(AppLocalizations? appLocale) async {
    appStore.setLoading(true);
    setState(() {});

    AuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verificationId!, smsCode: otpCode.validate());

    await FirebaseAuth.instance.signInWithCredential(credential).then((result) async {
      Map req = {
        'username': widget.phoneNumber!.replaceAll('+', ''),
        'password': widget.phoneNumber!.replaceAll('+', ''),
      };
      await login(req).then((value) async {
        await setValue(IS_SOCIAL_LOGIN, true);
        await setValue(LOGIN_TYPE, LoginTypeOTP);
        DashboardScreen().launch(context, isNewTask: true);
      }).catchError((e) {
        print("Inside Catch");
        appStore.setLoading(false);

        setState(() {});
        if (e.toString().contains('The username or password you entered is incorrect.')) {
          // if (e.toString().contains('invalid_username')) {
          finish(context);
          // finish(context);
          RegisterScreen(phoneNumber: widget.phoneNumber!.replaceAll('+', '')).launch(context);

          toast(appLocale!.translate('sign_up_to_continue'));
        } else {
          toast(e.toString());
        }
      });
    }).catchError((e) {
      appStore.setLoading(false);

      log(e);
      toast(e.toString());
      setState(() {});
    });
  }

  Future<void> sendOTP(AppLocalizations? appLocale) async {
    if (numberController.text.trim().isEmpty) {
      return toast(errorThisFieldRequired);
    }
    appStore.setLoading(true);

    setState(() {});

    String number = '+$countryCode${numberController.text.trim()}';
    if (!number.startsWith('+')) {
      number = '+$countryCode${numberController.text.trim()}';
    }
    try {
      await loginWithOTP(context, number).then((value) {}).catchError((e) async {
        await appStore.setLoading(false);

        setState(() {});

        toast(e.toString());
      });
    } catch (e) {
      appStore.setLoading(false);
      setState(() {});

      toast(e.toString());
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var appLocale = AppLocalizations.of(context);

    return Observer(builder: (context) {
      return Container(
        width: context.width(),
        child: !widget.isCodeSent.validate()
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appLocale!.translate('enter_your_phone'), style: boldTextStyle()),
                  30.height,
                  Container(
                    height: 100,
                    child: Row(
                      children: [
                        CountryCodePicker(
                          initialSelection: 'IN',
                          showCountryOnly: false,
                          showFlag: false,
                          showFlagDialog: true,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,
                          textStyle: primaryTextStyle(),
                          onInit: (c) {
                            countryCode = c!.dialCode;
                          },
                          onChanged: (c) {
                            countryCode = c.dialCode;
                          },
                        ),
                        8.width,
                        AppTextField(
                          controller: numberController,
                          textFieldType: TextFieldType.PHONE,
                          decoration: inputDecoration(context, hint: appLocale.translate('phone_number')),
                          autoFocus: true,
                          onFieldSubmitted: (s) {
                            sendOTP(appLocale);
                          },
                        ).expand(),
                      ],
                    ),
                  ),
                  30.height,
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      AppButton(
                        onTap: () {
                          sendOTP(appLocale);
                        },
                        text: appLocale.translate('send_otp'),
                        color: appStore.isDarkMode ? colorPrimary.withOpacity(0.7) : colorPrimary,
                        textStyle: boldTextStyle(color: white),
                        width: context.width(),
                      ),
                      Positioned(
                        //right: 16,
                        child: Loader().visible(appStore.isLoading),
                      ),
                    ],
                  )
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appLocale!.translate('enter_otp_received'), style: boldTextStyle()),
                  30.height,
                  otp.OTPTextField(
                    length: 6,
                    width: MediaQuery.of(context).size.width,
                    fieldWidth: 35,
                    style: primaryTextStyle(),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: otpStyle.FieldStyle.box,
                    onChanged: (s) {
                      otpCode = s;
                    },
                    onCompleted: (pin) {
                      otpCode = pin;
                      submit(appLocale);
                    },
                  ),
                  30.height,
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      AppButton(
                        onTap: () {
                          submit(appLocale);
                        },
                        text: appLocale.translate('confirm'),
                        color: appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimary,
                        textStyle: boldTextStyle(color: white),
                        width: context.width(),
                      ),
                      Positioned(
                        //right: 16,
                        child: Loader().visible(appStore.isLoading),
                      ),
                    ],
                  )
                ],
              ),
      );
    });
  }
}
