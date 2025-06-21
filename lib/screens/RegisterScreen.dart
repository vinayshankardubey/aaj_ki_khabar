import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../AppLocalizations.dart';
import '../network/RestApis.dart';
import '../screens/DashboardScreen.dart';
import '../../../utils/extension.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class RegisterScreen extends StatefulWidget {
  static String tag = '/RegisterScreen';
  final String? phoneNumber;

  RegisterScreen({this.phoneNumber});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode lastNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode passFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();

  bool passwordVisible = false;





  signUp() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      var request = {
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'user_login': widget.phoneNumber ?? userNameController.text,
        'user_email': emailController.text,
        'user_pass': widget.phoneNumber ?? passwordController.text,
      };
      appStore.setLoading(true);

      createUser(request).then((res) async {
        if (!mounted) return;

        Map req = {'username': widget.phoneNumber ?? emailController.text, 'password': widget.phoneNumber ?? passwordController.text};

        await login(req).then((value) async {
          appStore.setLoading(false);

          if (widget.phoneNumber != null) await setValue(LOGIN_TYPE, LoginTypeOTP);

          DashboardScreen().launch(context, isNewTask: true);
        }).catchError((e) {
          appStore.setLoading(false);
        });
      }).catchError((error) {
        appStore.setLoading(false);
        toast(error.toString());
      });
    }
  }

  @override
  void initState() {

    super.initState();
    init();
  }
  Future<void> init() async {
    appStore.setLoading(false);
  }
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        child: Stack(
          children: [
            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 30, top: 16, right: 16, left: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/app_logo.png', height: 100),
                    16.height,
                    Text(appLocalization.translate('signUp_Title'), style: boldTextStyle(size: 22)),
                    20.height,
                    AppTextField(
                      controller: firstNameController,
                      textFieldType: TextFieldType.NAME,
                      decoration: inputDecoration(context, hint: appLocalization.translate('first_Name')),
                      nextFocus: lastNameFocus,
                    ).paddingBottom(16),
                    AppTextField(
                      controller: lastNameController,
                      focus: lastNameFocus,
                      textFieldType: TextFieldType.NAME,
                      decoration: inputDecoration(context, hint: appLocalization.translate('last_Name')),
                      nextFocus: widget.phoneNumber != null ? emailFocus : userNameFocus,
                    ).paddingBottom(16),
                    AppTextField(
                      controller: userNameController,
                      focus: userNameFocus,
                      textFieldType: TextFieldType.NAME,
                      decoration: inputDecoration(context, hint: appLocalization.translate('username')),
                      nextFocus: emailFocus,
                      textCapitalization: TextCapitalization.none,
                      isValidationRequired: widget.phoneNumber == null,
                    ).paddingBottom(16).visible(widget.phoneNumber == null),
                    AppTextField(
                      controller: emailController,
                      focus: emailFocus,
                      textFieldType: TextFieldType.EMAIL,
                      decoration: inputDecoration(context, hint: appLocalization.translate('email')),
                      nextFocus: widget.phoneNumber != null ? null : passFocus,
                      errorThisFieldRequired: appLocalization.translate('field_Required'),
                      errorInvalidEmail: appLocalization.translate('email_Validation'),
                      maxLines: 1,
                      cursorColor: AppColors.redColor,
                    ).paddingBottom(16),
                    AppTextField(
                      controller: passwordController,
                      textFieldType: TextFieldType.PASSWORD,
                      focus: passFocus,
                      nextFocus: confirmPasswordFocus,
                      decoration: inputDecoration(context, hint: appLocalization.translate('password')),
                      errorMinimumPasswordLength: appLocalization.translate('password_Validation'),
                      isValidationRequired: widget.phoneNumber == null,
                    ).paddingBottom(16).visible(widget.phoneNumber == null),
                    AppTextField(
                      controller: confirmPasswordController,
                      textFieldType: TextFieldType.PASSWORD,
                      focus: confirmPasswordFocus,
                      decoration: inputDecoration(context, hint: appLocalization.translate('confirm_Pwd')),
                      onFieldSubmitted: (s) {
                        signUp();
                      },
                      validator: (value) {
                        if (value!.trim().isEmpty) return errorThisFieldRequired;
                        if (value.trim().length < passwordLengthGlobal) return passwordLengthMsg;
                        return passwordController.text == value.trim() ? null : appLocalization.translate('password_not_match');
                      },
                      isValidationRequired: widget.phoneNumber == null,
                    ).visible(widget.phoneNumber == null),
                    30.height,
                    AppButton(
                      text: appLocalization.translate('signUp'),
                      color: appStore.isDarkMode ? AppColors.scaffoldSecondaryDark : AppColors.greenColor,
                      textStyle: boldTextStyle(color: white),
                      onTap: () {
                        signUp();
                      },
                      width: context.width(),
                    ),
                    16.height,
                    AppButton(
                      text: appLocalization.translate('login'),
                      textStyle: boldTextStyle(color: textPrimaryColorGlobal),
                      color: appStore.isDarkMode ? AppColors.scaffoldSecondaryDark : white,
                      onTap: () {
                        finish(context);
                      },
                      width: context.width(),
                    ).visible(widget.phoneNumber == null),
                  ],
                ),
              ),
            ).center(),
            BackButton().paddingTop(30),
            Observer(builder: (_) => Loader().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
