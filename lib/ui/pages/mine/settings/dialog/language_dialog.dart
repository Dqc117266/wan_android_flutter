import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/utils/translations.dart';
import 'package:wan_android_flutter/core/viewmodel/app_settings_viewmodel.dart';
import 'package:wan_android_flutter/ui/shared/constants.dart';
import 'package:wan_android_flutter/ui/shared/dialog_helper.dart';

class LanguageDialog extends StatefulWidget {
  final AppSettingsViewModel viewModel;

  LanguageDialog(this.viewModel);

  @override
  _LanguageDialogState createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  late LanguageType languageType;
  bool isCanClickAction = false;

  @override
  void initState() {
    super.initState();
    languageType = widget.viewModel.languageType;
  }

  @override
  Widget build(BuildContext context) {
    return DialogHelper.CustomAlertDialog(
      context: context,
      title: Text(LocaleKeys.settings_language_title.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildLanguageItem(context, LanguageType.chinese),
          _buildLanguageItem(context, LanguageType.english),
        ],
      ),
      actionText: LocaleKeys.dialogAction.tr(),
      dismissText: LocaleKeys.dialogDismiss.tr(),
      onDismiss: () {},
      onAction: () {
        _onConfirm();
      },
      isCanClickAction: isCanClickAction,
    );
  }

  Widget _buildLanguageItem(BuildContext context, LanguageType language) {
    return ListTile(
      title: Text(languages[language.value]),
      leading: Radio<LanguageType>(
        value: language,
        groupValue: languageType,
        onChanged: (value) {
          setState(() {
            languageType = value!;
            isCanClickAction = languageType != widget.viewModel.languageType;
          });
        },
      ),
      onTap: () {
        setState(() {
          languageType = language;
          isCanClickAction = languageType != widget.viewModel.languageType;
        });
      },
    );
  }

  void _onConfirm() {
    switch (languageType) {
      case LanguageType.chinese:
        Locale chineseLocale = Translations.supportedLocales[1];
        if (EasyLocalization.of(context)!.supportedLocales.contains(chineseLocale)) {
          EasyLocalization.of(context)!.setLocale(chineseLocale);
        }
        break;
      case LanguageType.english:
        Locale englishLocale = Translations.supportedLocales[0];
        if (EasyLocalization.of(context)!.supportedLocales.contains(englishLocale)) {
          EasyLocalization.of(context)!.setLocale(englishLocale);
        }
        break;
    }

    Provider.of<AppSettingsViewModel>(context, listen: false)
        .setLanguageType(languageType.value);
  }
}
