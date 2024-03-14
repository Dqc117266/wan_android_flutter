import 'package:flutter/material.dart';
import 'package:wan_android_flutter/ui/pages/web/web_page.dart';

import '../../ui/pages/front/front_page.dart';
import '../../ui/pages/main/main_page.dart';

class MyRouter {
  static const initalRoute = MainScreen.routeName;

  static final Map<String, WidgetBuilder> routes = {
    WebPageScreen.routeName: (context) => WebPageScreen(),
  };
}