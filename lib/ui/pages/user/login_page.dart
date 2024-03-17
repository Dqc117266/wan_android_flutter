import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/ui/pages/user/register_page.dart';
import 'package:wan_android_flutter/ui/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  static final routeName = "/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  ValueNotifier<bool> userObscureTextNotifier = ValueNotifier<bool>(true);
  ValueNotifier<bool> passObscureTextNotifier = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.user_loginName.tr()),
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
                  controller: _controllerPassword,
                  labelText: LocaleKeys.user_passwordLable.tr(),
                  hintText: LocaleKeys.user_passwordHint.tr(),
                  obscureTextNotifier: passObscureTextNotifier,
                  isPassword: true,
                ),
                SizedBox(height: 24),
                _buildLoginButton(),
                SizedBox(height: 18),
                _buildToRegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      child: FilledButton(
        onPressed: () {
          
        },
        child: Text(LocaleKeys.user_loginName.tr()),
      ),
    );
  }

  Widget _buildToRegisterButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(RegisterScreen.routeName);
      },
      child: Text(LocaleKeys.user_toRegister.tr(),
          style: TextStyle(color: Theme.of(context).colorScheme.primary)),
    );
  }

}
