import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/notifiers/current_user_notifier.dart';
import 'package:rotaract/providers/auth_provider.dart';
import 'package:rotaract/ui/home_screen/home_screen.dart';
import 'package:rotaract/ui/nutritionists_screen/nutritionists_screen.dart';
import 'package:rotaract/ui/profile_screen/new_profile_screen.dart';

class MainTabsScreen extends ConsumerStatefulWidget {
  const MainTabsScreen({super.key});

  @override
  ConsumerState<MainTabsScreen> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends ConsumerState<MainTabsScreen> {
  final _screens = const [
    HomeScreen(),
    NutritionistsScreen(),
    NewProfileScreen(),
  ];
  int _selectedScreenIndex = 0;
  void _selectScreen(int index) {
    setState(() => _selectedScreenIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(watchCurrentUserProvider, (_, next) {
      next.whenData(
        (value) =>
            ref.read(currentUserNotifierProvider.notifier).updateUser(value),
      );
    });
    return Scaffold(
      body: _screens[_selectedScreenIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedScreenIndex,
        onDestinationSelected: _selectScreen,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        animationDuration: const Duration(milliseconds: 1000),
        destinations: const [
          NavigationDestination(
            label: "Home",
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
          ),
          NavigationDestination(
            label: "Team",
            icon: Icon(Icons.people_alt_outlined),
            selectedIcon: Icon(Icons.people),
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
