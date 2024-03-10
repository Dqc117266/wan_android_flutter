
import 'package:flutter/cupertino.dart';
import 'package:wan_android_flutter/ui/pages/front/front_page.dart';

import '../../ui/pages/main/main_page.dart';

class MyRouter {
  static const initalRoute = MainScreen.routeName;

  static final Map<String, WidgetBuilder> routes = {
    MainScreen.routeName: (context) => MainScreen(),
    FrontScreen.routeName: (context) => FrontScreen(),
  };
}