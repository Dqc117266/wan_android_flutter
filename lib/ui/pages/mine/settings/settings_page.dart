import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/viewmodel/app_settings_viewmodel.dart';
import 'package:wan_android_flutter/ui/pages/mine/settings/dialog/language_dialog.dart';
import 'package:wan_android_flutter/ui/pages/mine/settings/dialog/select_color_dialog.dart';
import 'package:wan_android_flutter/ui/pages/mine/settings/dialog/theme_model_dialog.dart';
import 'package:wan_android_flutter/ui/pages/mine/settings/settings_item.dart';
import 'package:wan_android_flutter/ui/shared/constants.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = "/settings";

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.mine_settings.tr()),
      ),
      body: Consumer<AppSettingsViewModel>(
        builder: (context, viewModel, child) {
          String curLanguage = languages[viewModel.languageType.value];
          String curMode = _getCurModeString(viewModel.themeMode);

          return ListView(
            children: [
              SettingsItem(
                onTap: () {
                  _showSelectColorDialog(context, viewModel);
                },
                title: LocaleKeys.settings_theme_title.tr(),
                subtitle: LocaleKeys.settings_theme_content.tr(),
                trailing: Icon(
                  Icons.circle,
                  size: 64,
                  color: viewModel.colorSeed.color,
                ),
              ),
              Divider(),
              SettingsItem(
                  onTap: () {
                    _showThemeModeDialog(context, viewModel);
                  },
                  title: LocaleKeys.settings_themeMode_title.tr(),
                  subtitle: LocaleKeys.settings_themeMode_content.tr(),
                  trailing: Text(
                    curMode,
                    style: Theme.of(context).textTheme.titleSmall,
                  )
              ),
              Divider(),
              SettingsItem(
                onTap: () {
                  _showSelectLanguageDialog(context, viewModel);
                },
                title: LocaleKeys.settings_language_title.tr(),
                subtitle: LocaleKeys.settings_language_content.tr(),
                trailing: Text(
                  curLanguage,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSelectColorDialog(BuildContext context, AppSettingsViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SelectColorDialog(viewModel: viewModel);
      },
    );
  }

  void _showSelectLanguageDialog(BuildContext context, AppSettingsViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LanguageDialog(viewModel);
      },
    );
  }

  void _showThemeModeDialog(BuildContext context, AppSettingsViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ThemeModelDialog(viewModel);
      },
    );
  }

  String _getCurModeString(ThemeMode themeMode) {
    String mode;
    switch (themeMode) {
      case ThemeMode.system:
        mode = LocaleKeys.settings_themeMode_system.tr();
        break;
      case ThemeMode.light:
        mode = LocaleKeys.settings_themeMode_light.tr();
        break;
      case ThemeMode.dark:
        mode = LocaleKeys.settings_themeMode_dark.tr();
        break;
    }

    return mode;
  }


}
