import 'package:flutter/material.dart';
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
          destinations: bottomNavigationBarItems,
        ),
      ),
    );
  }
}
