import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import '../../shared/constants.dart';
import 'initalize_items.dart';

class MainScreen extends StatefulWidget {
  static const routeName = "/";

  const MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late PageController _keepActiveVC;
  int screenIndex = ScreenSelected.front.value;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _keepActiveVC = PageController(initialPage: screenIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: PageView(
        controller: _keepActiveVC,
        physics: NeverScrollableScrollPhysics(),
        children: pages,
        onPageChanged: (index) {
          screenIndex = index;
        },
      ),
      bottomNavigationBar: Focus(
        autofocus: false,
        child: NavigationBar(
          selectedIndex: screenIndex,
          onDestinationSelected: (index) {
            setState(() {
              screenIndex = index;
              _keepActiveVC.jumpToPage(index);
            });
          },
          destinations: getBottomNavigationBarItems(),
        ),
      ),
    );
  }

  List<NavigationDestination> getBottomNavigationBarItems() {
    return [
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
  }

}
