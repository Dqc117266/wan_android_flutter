import 'package:flutter/material.dart';
import 'package:wan_android_flutter/ui/pages/search/custom_search_delegate.dart';
import 'package:wan_android_flutter/ui/pages/web/web_page.dart';
import '../../shared/constants.dart';
import 'initalize_items.dart';

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
      appBar: AppBar(
        title: Text(appBarNames[screenIndex]),
        actions: [
          if (screenIndex == 0)
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
              icon: Icon(Icons.search),
            ),
        ],
      ),
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
