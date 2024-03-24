import 'package:flutter/material.dart';
import 'package:wan_android_flutter/ui/pages/mine/collect/collect_screen.dart';
import 'package:wan_android_flutter/ui/pages/mine/integral/history/history_page.dart';
import 'package:wan_android_flutter/ui/pages/mine/integral/integral.dart';
import 'package:wan_android_flutter/ui/pages/mine/settings/settings_page.dart';
import 'package:wan_android_flutter/ui/pages/mine/todo/todo_page.dart';
import 'package:wan_android_flutter/ui/pages/search/search_page.dart';
import 'package:wan_android_flutter/ui/pages/user/login_page.dart';
import 'package:wan_android_flutter/ui/pages/user/register_page.dart';
import 'package:wan_android_flutter/ui/pages/mine/userinfo/userinfo_page.dart';
import 'package:wan_android_flutter/ui/pages/web/web_page.dart';

import '../../ui/pages/main/main_page.dart';

class MyRouter {
  static const initalRoute = MainScreen.routeName;

  static final Map<String, WidgetBuilder> routes = {
    WebPageScreen.routeName: (context) => WebPageScreen(),
    LoginScreen.routeName: (context) => LoginScreen(),
    RegisterScreen.routeName: (context) => RegisterScreen(),
    SearchScreen.routeName: (context) => SearchScreen(),
    UserInfoScreen.routeName: (context) => UserInfoScreen(),
    IntegralScreen.routeName: (context) => IntegralScreen(),
    CollectScreen.routeName: (context) => CollectScreen(),
    SettingsScreen.routeName: (context) => SettingsScreen(),
    TodoScreen.routeName: (context) => TodoScreen(),
    HistoryScreen.routeName: (context) => HistoryScreen(),
  };

  static void pushFromRight(BuildContext context, Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        },
      ),
    );
  }

}