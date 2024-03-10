import 'package:flutter/material.dart';
import 'package:wan_android_flutter/ui/pages/front/front_page.dart';
import 'package:wan_android_flutter/ui/pages/mine/mine_page.dart';
import 'package:wan_android_flutter/ui/pages/official/official_accounts_page.dart';
import 'package:wan_android_flutter/ui/pages/projects/projects_page.dart';
import 'package:wan_android_flutter/ui/widgets/navigation/navigation_bars.dart';
import 'package:wan_android_flutter/ui/widgets/navigation/navigation_transition.dart';

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
  late final AnimationController controller;
  late final CurvedAnimation railAnimation;
  bool controllerInitialized = false;
  bool showMediumSizeLayout = false;
  bool showLargeSizeLayout = false;

  int screenIndex = ScreenSelected.front.value;

  @override
  initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: transitionLength.toInt() * 2),
      value: 0,
      vsync: this,
    );
    railAnimation = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0),
    );
  }

  void handleScreenChanged(int screenSelected) {
    setState(() {
      screenIndex = screenSelected;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return NavigationTransition(
            scaffoldKey: scaffoldKey,
            animationController: controller,
            railAnimation: railAnimation,
            navigationBar: NavigationBars(
              onSelectItem: (index) {
                setState(() {
                  screenIndex = index;
                  // handleScreenChanged(screenIndex);
                });
              },
              selectedIndex: screenIndex,
            ),
            body: createScreenFor(
                ScreenSelected.values[screenIndex], controller.value == 1),
          );
        });
  }
}

Widget createScreenFor(
  ScreenSelected screenSelected,
  bool showNavBarExample,
) =>
    switch (screenSelected) {
      ScreenSelected.front => const FrontScreen(),
      ScreenSelected.projects => const ProjectsScreen(),
      ScreenSelected.officialAccounts => const OfficialAccountsScreen(),
      ScreenSelected.mine => const MineScreen()
    };
