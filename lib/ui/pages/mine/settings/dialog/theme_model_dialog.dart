import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/viewmodel/app_settings_viewmodel.dart';
import 'package:wan_android_flutter/ui/shared/dialog_helper.dart';

class ThemeModelDialog extends StatefulWidget {
  final AppSettingsViewModel viewModel;

  ThemeModelDialog(this.viewModel);

  @override
  State<ThemeModelDialog> createState() => _ThemeModelDialogState();
}

class _ThemeModelDialogState extends State<ThemeModelDialog> {
  late ThemeMode modeType;
  bool isCanClickAction = false;

  @override
  void initState() {
    super.initState();
    modeType = widget.viewModel.themeMode;
  }

  @override
  Widget build(BuildContext context) {
    return DialogHelper.CustomAlertDialog(
      context: context,
      title: Text(LocaleKeys.settings_language_title.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildLanguageItem(context, ThemeMode.system),
          _buildLanguageItem(context, ThemeMode.light),
          _buildLanguageItem(context, ThemeMode.dark),
        ],
      ),
      actionText: LocaleKeys.dialogAction.tr(),
      dismissText: LocaleKeys.dialogDismiss.tr(),
      onDismiss: () {},
      onAction: () {
        _onConfirm();
      },
      isCanClickAction: isCanClickAction,
    );  }


  Widget _buildLanguageItem(BuildContext context, ThemeMode mode) {
    return ListTile(
      title: Text(_getCurModeString(mode)),
      leading: Radio<ThemeMode>(
        value: mode,
        groupValue: modeType,
        onChanged: (value) {
          setState(() {
            modeType = value!;
          });
        },
      ),
      onTap: () {
        setState(() {
          modeType = mode;
          isCanClickAction = modeType != widget.viewModel.themeMode;
        });
      },
    );
  }

  void _onConfirm() {

    Provider.of<AppSettingsViewModel>(context, listen: false)
        .setThemeMode(modeType.index);

  }

  String _getCurModeString(ThemeMode themeModeType) {
    String mode;
    switch (themeModeType) {
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
