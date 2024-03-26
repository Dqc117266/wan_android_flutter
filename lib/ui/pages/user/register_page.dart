import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/utils/toast_utils.dart';
import 'package:wan_android_flutter/network/http_creator.dart';
import 'package:wan_android_flutter/ui/pages/user/login_page.dart';
import 'package:wan_android_flutter/ui/shared/dialog_helper.dart';
import 'package:wan_android_flutter/ui/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  static final routeName = "/register";

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerRePassword = TextEditingController();

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _rePasswordFocusNode = FocusNode();

  ValueNotifier<bool> userObscureTextNotifier = ValueNotifier<bool>(true);
  ValueNotifier<bool> obscureTextNotifier = ValueNotifier<bool>(true);
  ValueNotifier<bool> reObscureTextNotifier = ValueNotifier<bool>(true);

  String? _usernameError = LocaleKeys.user_usernameError.tr();
  String? _passwordError = LocaleKeys.user_passwordError.tr();
  String? _rePasswordError = LocaleKeys.user_rePsswordError.tr();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerUsername.addListener(isButtonEnabled);
    _controllerPassword.addListener(isButtonEnabled);
    _controllerRePassword.addListener(isButtonEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.user_registerName.tr()),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomTextField(
                  focusNode: _usernameFocusNode,
                  controller: _controllerUsername,
                  labelText: LocaleKeys.user_userLabel.tr(),
                  hintText: LocaleKeys.user_userHint.tr(),
                  obscureTextNotifier: userObscureTextNotifier,
                  errorText: _usernameError,
                ),
                SizedBox(height: 16),
                CustomTextField(
                  focusNode: _passwordFocusNode,
                  obscureTextNotifier: obscureTextNotifier,
                  controller: _controllerPassword,
                  labelText: LocaleKeys.user_passwordLable.tr(),
                  hintText: LocaleKeys.user_passwordHint.tr(),
                  isPassword: true,
                  errorText: _passwordError,
                ),
                SizedBox(height: 16),
                CustomTextField(
                  focusNode: _rePasswordFocusNode,
                  obscureTextNotifier: reObscureTextNotifier,
                  controller: _controllerRePassword,
                  labelText: LocaleKeys.user_rePasswordLable.tr(),
                  hintText: LocaleKeys.user_rePasswordHint.tr(),
                  isPassword: true,
                  errorText: _rePasswordError,
                ),
                SizedBox(
                  height: 24,
                ),
                _buildRegisterButton(),
                SizedBox(height: 18),
                _buildToLoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      width: double.infinity,
      child: FilledButton(
        onPressed: isButtonEnabled()
            ? () {
                _register();
              }
            : null,
        child: Text(LocaleKeys.user_registerName.tr()),
      ),
    );
  }

  Widget _buildToLoginButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(LoginScreen.routeName);
      },
      child: Text(LocaleKeys.user_toLogin.tr(),
          style: TextStyle(color: Theme.of(context).colorScheme.primary)),
    );
  }

  void _register() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_controllerRePassword.text != _controllerPassword.text) {
      ToastUtils.showShortToast(LocaleKeys.user_rePsswordError.tr());
      return;
    }

    DialogHelper.showLoadingDialog(context, LocaleKeys.user_registeing.tr());

    HttpCreator.register(_controllerUsername.text, _controllerPassword.text,
            _controllerRePassword.text)
        .then((value) {

      if (value.errorCode == 0) {
        ToastUtils.showShortToast(LocaleKeys.user_registed.tr());
        Navigator.of(context).pop();
      } else {
        ToastUtils.showShortToast(value.errorMsg!);
      }

      Navigator.of(context).pop();

    })
      ..onError((error, stackTrace) {
        ToastUtils.showShortToast(LocaleKeys.user_networkError.tr());

        Navigator.of(context).pop();
      });
  }

  bool isButtonEnabled() {
    setState(() {});
    return _controllerUsername.text.length >= 6 &&
        _controllerPassword.text.length >= 6 &&
        _controllerRePassword.text.length >= 6;
  }
}
