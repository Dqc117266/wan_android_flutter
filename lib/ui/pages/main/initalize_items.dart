import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/ui/pages/front/front_page.dart';

const List<Widget> pages = [
  FrontScreen(),
  FrontScreen(),
  FrontScreen(),
  FrontScreen(),
];

final List<BottomNavigationBarItem> items = [
  BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: LocaleKeys.tableNames_frontPage.tr(),
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.apps),
    label: LocaleKeys.tableNames_projects.tr(),
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.public),
    label: LocaleKeys.tableNames_officialAccounts.tr(),
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person),
    label: LocaleKeys.tableNames_mine.tr(),
  ),
];
