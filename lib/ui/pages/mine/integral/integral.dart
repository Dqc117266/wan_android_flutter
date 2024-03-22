import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';

class IntegralScreen extends StatelessWidget {
  static const routeName = "/integral";

  const IntegralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.mine_myScores.tr()),),
      body: Center(
        child: Text("积分"),
      ),
    );
  }
}
