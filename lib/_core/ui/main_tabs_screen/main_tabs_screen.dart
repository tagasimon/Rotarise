import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/tab_index_notifier.dart';

import 'package:rotaract/discover/ui/discover_screen/discover_clubs_screen.dart';
import 'package:rotaract/_core/ui/profile_screen/ui/profile_screen/profile_screen.dart';

class MainTabsScreen extends ConsumerStatefulWidget {
  const MainTabsScreen({super.key});

  @override
  ConsumerState<MainTabsScreen> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends ConsumerState<MainTabsScreen> {
  final _screens = const [
    // HomeScreen(),
    DiscoverClubsScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    final tabIndex = ref.watch(tabIndexProvider);
    return Scaffold(
      body: _screens[tabIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: tabIndex,
        onDestinationSelected: (index) {
          ref.read(tabIndexProvider.notifier).setTabIndex(index);
        },
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        animationDuration: const Duration(milliseconds: 1000),
        destinations: const [
          // NavigationDestination(
          //   label: "Home",
          //   icon: Icon(Icons.home_outlined),
          //   selectedIcon: Icon(Icons.home),
          // ),
          NavigationDestination(
            label: "Home",
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
          ),

          NavigationDestination(
            label: "Profile",
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
