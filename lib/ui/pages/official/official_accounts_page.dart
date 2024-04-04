import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/core/viewmodel/app_settings_viewmodel.dart';
import 'package:wan_android_flutter/network/http_creator.dart';
import 'package:wan_android_flutter/ui/widgets/tab_page.dart';

import '../../../core/lang/locale_keys.g.dart';

class OfficialAccountsScreen extends StatelessWidget {
  const OfficialAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer<AppSettingsViewModel>(
      builder: (context, viewmodel, child) {
        return TabbedPage(
            title: LocaleKeys.tableNames_officialAccounts.tr(),
            getTreeModel: HttpCreator.wxarticleChapters,
            getDataList: HttpCreator.wxarticleList);
      },
    );
  }
}
