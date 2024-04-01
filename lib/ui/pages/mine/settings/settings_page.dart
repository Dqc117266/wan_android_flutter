import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/ui/pages/mine/settings/settings_item.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = "/settings";

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.mine_settings.tr()),),
      body: ListView(
        children: [
          SettingsItem(
            title: 'Dark Mode',
            trailing: Switch(
              value: false, // Replace with actual value
              onChanged: (value) {
                // Handle switch value change
              },
            ),
          ),
          Divider(), // Divider for visual separation
          SettingsItem(
            onTap: () {},
            title: '主题色',
            subtitle: '更改应用程序的主题颜色',
            trailing: Switch(
              value: true, // Replace with actual value
              onChanged: (value) {
                // Handle switch value change
              },
            ),
          ),

        ],
      ),
    );
  }
}

