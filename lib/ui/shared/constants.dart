import 'package:flutter/material.dart';

import '../../core/lang/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

const double transitionLength = 500;

List<dynamic> getItemBorderRadius(int index, int length) {
  final BorderRadius borderRadius;
  bool isBottomLine = true;

  if (length == 1) {
    borderRadius = BorderRadius.all(Radius.circular(12));
    isBottomLine = false;
  } else if (index == 0) {
    borderRadius = BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12));
  } else if (index == length - 1) {
    borderRadius = BorderRadius.only(
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12));
    isBottomLine = false;
  } else {
    borderRadius = BorderRadius.zero;
  }
  return [borderRadius, isBottomLine];
}

final List<String> appBarNames = [
  LocaleKeys.tableNames_frontPage.tr(),
  LocaleKeys.tableNames_projects.tr(),
  LocaleKeys.tableNames_officialAccounts.tr(),
  LocaleKeys.tableNames_mine.tr(),
];

final List<String> languages = [
  LocaleKeys.settings_language_chinese.tr(),
  LocaleKeys.settings_language_english.tr(),
];

final List<String> modes = [
  LocaleKeys.settings_themeMode_system.tr(),
  LocaleKeys.settings_themeMode_light.tr(),
  LocaleKeys.settings_themeMode_dark.tr(),
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

enum ToWebSource {
  bannerPage,
  articlePage;
}

enum TodoType {
  normal(0),
  star(1);

  const TodoType(this.value);
  final int value;
}

enum TodoStatus {
  unDone(0),
  done(1);

  const TodoStatus(this.value);
  final int value;
}

enum ThemeModeType {
  system(0),
  light(1),
  dark(2);

  const ThemeModeType(this.value);
  final int value;
}

enum UseMaterial {
  materialDesign2(false),
  materialDesign3(true);

  const UseMaterial(this.value);
  final bool value;
}

enum ChapterType {
  normal(0),
  top(1);

  const ChapterType(this.value);
  final int value;
}

enum LanguageType {
  chinese(0),
  english(1);

  const LanguageType(this.value);
  final int value;
}
