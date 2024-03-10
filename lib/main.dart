import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/router/router.dart';
import 'package:wan_android_flutter/ui/shared/app_theme.dart';

import 'core/utils/translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: Translations.supportedLocales,
      path: Translations.localesPath,
      fallbackLocale: const Locale('zh'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: LocaleKeys.appName.tr(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: AppTheme.normalTheme,
      initialRoute: MyRouter.initalRoute,
      routes: MyRouter.routes,
    );
  }
}
