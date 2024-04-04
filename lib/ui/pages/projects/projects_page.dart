import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/viewmodel/app_settings_viewmodel.dart';
import 'package:wan_android_flutter/network/http_creator.dart';
import 'package:wan_android_flutter/ui/widgets/tab_page.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsViewModel>(
      builder: (context, viewmodel, child) {
        return TabbedPage(
            title: LocaleKeys.tableNames_projects.tr(),
            getTreeModel: HttpCreator.getProjectClassify,
            getDataList: HttpCreator.getProjectList);
      },
    );
  }
}
