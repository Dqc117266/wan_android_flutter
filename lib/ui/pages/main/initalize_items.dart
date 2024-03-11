import 'package:flutter/material.dart';

import 'package:wan_android_flutter/ui/pages/front/front_page.dart';

import '../mine/mine_page.dart';
import '../official/official_accounts_page.dart';
import '../projects/projects_page.dart';

final List<Widget> pages = [
  FrontScreen(),
  ProjectsScreen(),
  OfficialAccountsScreen(),
  MineScreen(),
];
