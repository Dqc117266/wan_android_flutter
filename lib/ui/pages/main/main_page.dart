import 'package:flutter/material.dart';
import 'package:wan_android_flutter/ui/pages/front/front_page.dart';
import 'package:wan_android_flutter/ui/pages/mine/mine_page.dart';
import 'package:wan_android_flutter/ui/pages/official/official_accounts_page.dart';
import 'package:wan_android_flutter/ui/pages/projects/projects_page.dart';

import '../../shared/constants.dart';

class MainScreen extends StatefulWidget {
  static const routeName = "/";
  const MainScreen({
    super.key,
    required this.useLightMode,
    required this.useMaterial3,
    required this.colorSelected,
    required this.handleBrightnessChange,
    required this.handleMaterialVersionChange,
    required this.handleColorSelect,
    required this.handleImageSelect,
    required this.colorSelectionMethod,
    required this.imageSelected,
  });

  final bool useLightMode;
  final bool useMaterial3;
  final ColorSeed colorSelected;
  final ColorImageProvider imageSelected;
  final ColorSelectionMethod colorSelectionMethod;

  final void Function(bool useLightMode) handleBrightnessChange;
  final void Function() handleMaterialVersionChange;
  final void Function(int value) handleColorSelect;
  final void Function(int value) handleImageSelect;

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
      body: createScreenFor(ScreenSelected.values[screenIndex]),
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

Widget createScreenFor(
  ScreenSelected screenSelected,
) =>
    switch (screenSelected) {
      ScreenSelected.front => const FrontScreen(),
      ScreenSelected.projects => const ProjectsScreen(),
      ScreenSelected.officialAccounts => const OfficialAccountsScreen(),
      ScreenSelected.mine => const MineScreen()
    };
