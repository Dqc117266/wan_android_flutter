import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
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
      fallbackLocale: const Locale('zh'),
      child: const MyApp(),
    ),
  );
}


