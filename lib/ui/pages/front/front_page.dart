import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';

class FrontScreen extends StatelessWidget {
  static const routeName = "/front";
  const FrontScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.tableNames_frontPage.tr()),),
    );
  }
}
