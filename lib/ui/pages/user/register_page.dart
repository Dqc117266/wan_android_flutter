import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';

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

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.user_registerName.tr()),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: _controllerUsername,
                decoration: InputDecoration(
                  // prefixIcon: const Icon(Icons.search),
                  labelText: LocaleKeys.user_userLabel.tr(),
                  hintText: LocaleKeys.user_userHint.tr(),
                  border: const OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              TextField(
                controller: _controllerPassword,
                decoration: InputDecoration(
                  // prefixIcon: const Icon(Icons.search),
                  labelText: LocaleKeys.user_passwordLable.tr(),
                  hintText: LocaleKeys.user_passwordHint.tr(),
                  border: const OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              TextField(
                controller: _controllerRePassword,
                decoration: InputDecoration(
                  // prefixIcon: const Icon(Icons.search),
                  labelText: LocaleKeys.user_rePasswordLable.tr(),
                  hintText: LocaleKeys.user_rePasswordHint.tr(),
                  border: const OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {},
                  child: Text(LocaleKeys.user_registerName.tr()),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              GestureDetector(
                onTap: () {},
                child: Text(LocaleKeys.user_toLogin.tr(),
                    style: TextStyle(color: Theme.of(context).primaryColor)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
