import 'package:flutter/material.dart';

import '../../core/lang/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

const double transitionLength = 500;

final List<Widget> bottomNavigationBarItems = [
  NavigationDestination(
    tooltip: LocaleKeys.tableNames_frontPage.tr(),
    icon: Icon(Icons.home),
    label: LocaleKeys.tableNames_frontPage.tr(),
  ),
  NavigationDestination(
    tooltip: LocaleKeys.tableNames_projects.tr(),
    icon: Icon(Icons.layers),
    label: LocaleKeys.tableNames_projects.tr(),
  ),
  NavigationDestination(
    tooltip: LocaleKeys.tableNames_officialAccounts.tr(),
    icon: Icon(Icons.wechat),
    label: LocaleKeys.tableNames_officialAccounts.tr(),
  ),
  NavigationDestination(
    tooltip: LocaleKeys.tableNames_mine.tr(),
    icon: Icon(Icons.person),
    label: LocaleKeys.tableNames_mine.tr(),
  )
];

final List<String> appBarNames = [
  LocaleKeys.tableNames_frontPage.tr(),
  LocaleKeys.tableNames_projects.tr(),
  LocaleKeys.tableNames_officialAccounts.tr(),
  LocaleKeys.tableNames_mine.tr(),
];

enum ColorSelectionMethod {
  colorSeed,
  image,
}

enum ColorSeed {
  baseColor('M3 Baseline', Color(0xff6750a4)),
  indigo('Indigo', Colors.indigo),
  blue('Blue', Colors.blue),
  teal('Teal', Colors.teal),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  orange('Orange', Colors.orange),
  deepOrange('Deep Orange', Colors.deepOrange),
  pink('Pink', Colors.pink);

  const ColorSeed(this.label, this.color);

  final String label;
  final Color color;
}

enum ColorImageProvider {
  leaves('Leaves',
      'https://flutter.github.io/assets-for-api-docs/assets/material/content_based_color_scheme_1.png'),
  peonies('Peonies',
      'https://flutter.github.io/assets-for-api-docs/assets/material/content_based_color_scheme_2.png'),
  bubbles('Bubbles',
      'https://flutter.github.io/assets-for-api-docs/assets/material/content_based_color_scheme_3.png'),
  seaweed('Seaweed',
      'https://flutter.github.io/assets-for-api-docs/assets/material/content_based_color_scheme_4.png'),
  seagrapes('Sea Grapes',
      'https://flutter.github.io/assets-for-api-docs/assets/material/content_based_color_scheme_5.png'),
  petals('Petals',
      'https://flutter.github.io/assets-for-api-docs/assets/material/content_based_color_scheme_6.png');

  const ColorImageProvider(this.label, this.url);

  final String label;
  final String url;
}

enum ScreenSelected {
  front(0),
  projects(1),
  officialAccounts(2),
  mine(3);

  const ScreenSelected(this.value);
  final int value;
}

enum LoadState {
  loading,
  success,
  failed,
  end,
  empty;
}
