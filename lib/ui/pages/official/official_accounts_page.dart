import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/lang/locale_keys.g.dart';

class OfficialAccountsScreen extends StatelessWidget {
  const OfficialAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.tableNames_officialAccounts.tr()),),
      body: Center(
        child: Text("公众号"),
      ),
    );
  }
}
