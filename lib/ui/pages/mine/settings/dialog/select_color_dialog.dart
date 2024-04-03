import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/viewmodel/app_settings_viewmodel.dart';
import 'package:wan_android_flutter/ui/shared/constants.dart';
import 'package:wan_android_flutter/ui/shared/dialog_helper.dart';

class SelectColorDialog extends StatelessWidget {
  final AppSettingsViewModel viewModel;
  const SelectColorDialog({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return DialogHelper.CustomAlertDialog(
      context: context,
      title: Text(LocaleKeys.settings_theme_dialogTitle.tr()),
      content: Container(
        height: 200,
        width: 200,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          itemCount: ColorSeed.values.length,
          itemBuilder: (BuildContext context, int index) {
            final colorSeed = ColorSeed.values[index];
            return _buildColorSelectItem(context, index, viewModel, colorSeed);
          },
        ),
      ),
      dismissText: LocaleKeys.settings_theme_close.tr(),
    );
  }

  Widget _buildColorSelectItem(BuildContext context, int index,
      AppSettingsViewModel viewModel, ColorSeed colorSeed) {
    return GestureDetector(
      onTap: () {
        // 将选择的颜色保存起来
        final themeProvider =
        Provider.of<AppSettingsViewModel>(context, listen: false);
        themeProvider.setColorSeed(index);
        Navigator.of(context).pop(); // 关闭对话框
      },
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: ColorSeed.values[index] == viewModel.colorSeed
            ? BoxDecoration(
            shape: BoxShape.circle,
            border:
            Border.all(color: viewModel.colorSeed.color, width: 4.0))
            : null,
        child: CircleAvatar(
          backgroundColor: colorSeed.color,
          radius: 16.0,
        ),
      ),
    );
  }
}
