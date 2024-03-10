import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';

class NavigationBars extends StatefulWidget {
  const NavigationBars({
    super.key,
    this.onSelectItem,
    required this.selectedIndex,
  });

  final void Function(int)? onSelectItem;
  final int selectedIndex;


  @override
  State<NavigationBars> createState() => _NavigationBarsState();
}

class _NavigationBarsState extends State<NavigationBars> {
  late int selectedIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(covariant NavigationBars oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      selectedIndex = widget.selectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget navigationBar = Focus(
      autofocus: false,
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
          widget.onSelectItem!(index);
          // if (!widget.isExampleBar) widget.onSelectItem!(index);
        },
        destinations: items,
      ),
    );

    return navigationBar;
  }
}

final List<Widget> items = [
  NavigationDestination(
    icon: Icon(Icons.home),
    label: LocaleKeys.tableNames_frontPage.tr(),
  ),
  NavigationDestination(
    icon: Icon(Icons.layers),
    label: LocaleKeys.tableNames_projects.tr(),
  ),
  NavigationDestination(
    icon: Icon(Icons.wechat),
    label: LocaleKeys.tableNames_officialAccounts.tr(),
  ),
  NavigationDestination(
    icon: Icon(Icons.person),
    label: LocaleKeys.tableNames_mine.tr(),
  )
];
