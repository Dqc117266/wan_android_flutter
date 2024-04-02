import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/core/viewmodel/theme_viewmodel.dart';
import 'package:wan_android_flutter/ui/pages/web/web_page.dart';
import '../core/lang/locale_keys.g.dart';
import '../core/router/router.dart';
import 'pages/main/main_page.dart';
import 'shared/constants.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool useMaterial3 = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeViewModel>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: LocaleKeys.appName.tr(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        colorSchemeSeed: themeProvider.colorSeed.color,
        useMaterial3: useMaterial3,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: themeProvider.colorSeed.color,
        useMaterial3: useMaterial3,
        brightness: Brightness.dark,
      ),
      initialRoute: MyRouter.initalRoute,
      routes: MyRouter.routes,
    );
  }
}
