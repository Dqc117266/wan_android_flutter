import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/ui/pages/user/login_page.dart';
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

  ValueNotifier<bool> userObscureTextNotifier = ValueNotifier<bool>(true);
  ValueNotifier<bool> obscureTextNotifier = ValueNotifier<bool>(true);
  ValueNotifier<bool> reObscureTextNotifier = ValueNotifier<bool>(true);

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
                  controller: _controllerUsername,
                  labelText: LocaleKeys.user_userLabel.tr(),
                  hintText: LocaleKeys.user_userHint.tr(),
                  obscureTextNotifier: userObscureTextNotifier,
                ),
                SizedBox(height: 16),
                CustomTextField(
                  obscureTextNotifier: obscureTextNotifier,
                  controller: _controllerPassword,
                  labelText: LocaleKeys.user_passwordLable.tr(),
                  hintText: LocaleKeys.user_passwordHint.tr(),
                  isPassword: true,
                ),
                SizedBox(height: 16),
                CustomTextField(
                  obscureTextNotifier: reObscureTextNotifier,
                  controller: _controllerRePassword,
                  labelText: LocaleKeys.user_rePasswordLable.tr(),
                  hintText: LocaleKeys.user_rePasswordHint.tr(),
                  isPassword: true,
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
        onPressed: () {},
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
}
