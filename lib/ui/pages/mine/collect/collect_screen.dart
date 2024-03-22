import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';

class CollectScreen extends StatelessWidget {
  static const routeName = "/collect";

  const CollectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.mine_myCollect.tr()),),
      body: Center(
        child: Text("收藏"),
      ),
    );
  }
}
