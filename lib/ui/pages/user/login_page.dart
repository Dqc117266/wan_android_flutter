import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/model/user_info_model.dart';
import 'package:wan_android_flutter/core/utils/toast_utils.dart';
import 'package:wan_android_flutter/core/utils/userinfo_storage.dart';
import 'package:wan_android_flutter/core/viewmodel/user_viewmodel.dart';
import 'package:wan_android_flutter/network/http_creator.dart';
import 'package:wan_android_flutter/ui/pages/user/register_page.dart';
import 'package:wan_android_flutter/ui/shared/dialog_helper.dart';
import 'package:wan_android_flutter/ui/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  static final routeName = "/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  ValueNotifier<bool> userObscureTextNotifier = ValueNotifier<bool>(true);
  ValueNotifier<bool> passObscureTextNotifier = ValueNotifier<bool>(true);

  String? _usernameError = "账号必须至少有6个字符";
  String? _passwordError = "密码必须至少有6个字符";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerUsername.addListener(isButtonEnabled);
    _controllerPassword.addListener(isButtonEnabled);
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

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
                  controller: _controllerPassword,
                  labelText: LocaleKeys.user_passwordLable.tr(),
                  hintText: LocaleKeys.user_passwordHint.tr(),
                  obscureTextNotifier: passObscureTextNotifier,
                  isPassword: true,
                  errorText: _passwordError,
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
        onPressed: isButtonEnabled()
            ? () {
                login();
              }
            : null,
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

  bool isButtonEnabled() {
    setState(() {});
    return _controllerUsername.text.length >= 6 &&
        _controllerPassword.text.length >= 6;
  }

  void login() {
    DialogHelper.showLoadingDialog(context, "正在登陆...");

    final login =
        HttpCreator.login(_controllerUsername.text, _controllerPassword.text);
    login.then((value) {
      Navigator.of(context).pop();//关闭弹窗

      UserInfoModel userInfoModel = value;

      if (userInfoModel != null && userInfoModel.errorCode == 0) {
        UserUtils.saveUserInfo(userInfoModel)
            .then((value) => Provider.of<UserViewModel>(context).updateUser());

        Navigator.of(context).pop();//关闭当前页面

        ToastUtils.showShortToast("登陆成功");
      } else {
        ToastUtils.showShortToast(userInfoModel.errorMsg!);
      }
    })
      ..onError((error, stackTrace) {
        Navigator.of(context).pop();//关闭弹窗

        ToastUtils.showShortToast(LocaleKeys.user_networkError.tr());
      });
  }
}
