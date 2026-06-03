import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../club/pages/club_page.dart';
import '../../home/pages/home_page.dart';
import '../../profile/pages/profile_page.dart';
import '../../search/pages/search_page.dart';
import '../controllers/shell_controller.dart';

/// Root app shell: hosts the four primary tabs in an [IndexedStack] (so each
/// tab keeps its scroll/state) and a Material 3 [NavigationBar] driven by the
/// [ShellController].
class ShellPage extends GetView<ShellController> {
  const ShellPage({super.key});

  static const List<Widget> _tabs = [
    HomePage(),
    SearchPage(),
    ClubPage(),
    ProfilePage(),
  ];

  static const List<_TabItem> _items = [
    _TabItem(Icons.home_outlined, Icons.home, AppStrings.navHome),
    _TabItem(Icons.search, Icons.search, AppStrings.navSearch),
    _TabItem(
      Icons.workspace_premium_outlined,
      Icons.workspace_premium,
      AppStrings.navClub,
    ),
    _TabItem(Icons.person_outline, Icons.person, AppStrings.navProfile),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex,
          children: _tabs,
        ),
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.currentIndex,
          onDestinationSelected: controller.changeTab,
          destinations: [
            for (final item in _items)
              NavigationDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.selectedIcon),
                label: item.label,
              ),
          ],
        ),
      ),
    );
  }
}

/// Immutable description of a bottom-navigation entry.
class _TabItem {
  const _TabItem(this.icon, this.selectedIcon, this.label);

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
