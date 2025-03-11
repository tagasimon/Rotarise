import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/features/auth/notifiers/current_user_notifier.dart';
import 'package:rotaract/features/auth/providers/auth_provider.dart';
import 'package:rotaract/features/core/presentation/screens/home_screen.dart';
import 'package:rotaract/features/events/events_screen.dart';

class MainTabsScreen extends ConsumerStatefulWidget {
  const MainTabsScreen({super.key});

  @override
  ConsumerState<MainTabsScreen> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends ConsumerState<MainTabsScreen> {
  final _screens = const [
    HomeScreen(),
    // ClubsScreen(),
    // AddPostScreen(),
    EventsScreen(),
    // ProfileScreen(),
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
          // NavigationDestination(
          //   label: "Clubs",
          //   icon: Icon(Icons.group_work_outlined),
          //   selectedIcon: Icon(Icons.group_work),
          // ),
          NavigationDestination(
            label: "Events",
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event_sharp),
          ),
          // NavigationDestination(
          //   label: "Profile",
          //   icon: Icon(Icons.person_outline),
          //   selectedIcon: Icon(Icons.person),
          // ),
        ],
      ),
    );
  }
}
