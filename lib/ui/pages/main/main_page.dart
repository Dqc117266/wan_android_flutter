import 'package:flutter/material.dart';
import 'package:wan_android_flutter/ui/pages/search/custom_search_delegate.dart';
import 'package:wan_android_flutter/ui/pages/web/web_page.dart';
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
  int screenIndex = ScreenSelected.front.value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: IndexedStack(
        index: screenIndex,
        children: pages,
      ),
      bottomNavigationBar: Focus(
        autofocus: false,
        child: NavigationBar(
          selectedIndex: screenIndex,
          onDestinationSelected: (index) {
            setState(() {
              screenIndex = index;
            });
          },
          destinations: bottomNavigationBarItems,
        ),
      ),
    );
  }
}
