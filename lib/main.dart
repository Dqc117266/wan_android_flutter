import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/core/viewmodel/app_settings_viewmodel.dart';
import 'package:wan_android_flutter/core/viewmodel/user_viewmodel.dart';
import 'core/utils/translations.dart';
import 'ui/app.dart';
import 'ui/shared/shared_preferences_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SharedPreferencesHelper.initialize();

  runApp(
    EasyLocalization(
      supportedLocales: Translations.supportedLocales,
      path: Translations.localesPath,
      fallbackLocale: Translations.supportedLocales[1],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserViewModel()),
          ChangeNotifierProvider(create: (context) => AppSettingsViewModel()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}


