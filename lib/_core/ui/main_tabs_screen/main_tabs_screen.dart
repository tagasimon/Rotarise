import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/extensions/color_extension.dart';
import 'package:rotaract/_core/notifiers/tab_index_notifier.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/news_feed_screen.dart';

import 'package:rotaract/discover/ui/discover_screen/discover_clubs_screen.dart';
import 'package:rotaract/_core/ui/profile_screen/ui/profile_screen/profile_screen.dart';

class MainTabsScreen extends ConsumerStatefulWidget {
  const MainTabsScreen({super.key});

  @override
  ConsumerState<MainTabsScreen> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends ConsumerState<MainTabsScreen> {
  final Set<int> _loadedScreens = {0}; // Only NewsFeedScreen loaded initially

  void _onTabTapped(int index) {
    final currentIndex = ref.read(tabIndexProvider);
    if (currentIndex == index) return;

    // Mark screen as loaded when first accessed
    setState(() {
      _loadedScreens.add(index);
    });

    ref.read(tabIndexProvider.notifier).setTabIndex(index);
  }

  Widget _buildScreen(int index) {
    if (!_loadedScreens.contains(index)) {
      return _PlaceholderScreen(screenName: _getScreenName(index));
    }

    switch (index) {
      case 0:
        return const NewsFeedScreen();
      case 1:
        return const DiscoverClubsScreen();
      case 2:
        return const ProfileScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  String _getScreenName(int index) {
    switch (index) {
      case 1:
        return "Discover";
      case 2:
        return "Profile";
      default:
        return "Screen";
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabIndex = ref.watch(tabIndexProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: tabIndex,
        children: [
          _buildScreen(0), // NewsFeedScreen
          _buildScreen(1), // DiscoverClubsScreen
          _buildScreen(2), // ProfileScreen
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(theme, tabIndex),
    );
  }

  Widget _buildBottomNavBar(ThemeData theme, int tabIndex) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlphaa(0.08), // Reduced opacity
            blurRadius: 16, // Reduced blur
            offset: const Offset(0, 4), // Single shadow
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outline.withAlphaa(0.1),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: NavigationBar(
          selectedIndex: tabIndex,
          onDestinationSelected: _onTabTapped,
          backgroundColor: Colors.transparent,
          elevation: 0,
          height: 65,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          animationDuration: const Duration(milliseconds: 300), // Reduced
          indicatorColor: theme.primaryColor.withAlphaa(0.15),
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          destinations: [
            _buildOptimizedDestination(
              index: 0,
              currentIndex: tabIndex,
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              label: "Feed",
              primaryColor: theme.primaryColor,
            ),
            _buildOptimizedDestination(
              index: 1,
              currentIndex: tabIndex,
              icon: Icons.explore_outlined,
              selectedIcon: Icons.explore,
              label: "Discover",
              primaryColor: theme.primaryColor,
            ),
            _buildOptimizedDestination(
              index: 2,
              currentIndex: tabIndex,
              icon: Icons.person_outline_rounded,
              selectedIcon: Icons.person_rounded,
              label: "Profile",
              primaryColor: theme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  NavigationDestination _buildOptimizedDestination({
    required int index,
    required int currentIndex,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required Color primaryColor,
  }) {
    final isSelected = index == currentIndex;

    return NavigationDestination(
      label: label,
      icon: Container(
        padding: const EdgeInsets.all(12),
        child: Icon(
          isSelected ? selectedIcon : icon,
          color: isSelected ? primaryColor : Colors.grey.shade600,
          size: isSelected ? 26 : 24, // Reduced size difference
        ),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String screenName;

  const _PlaceholderScreen({required this.screenName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Loading $screenName...', // Simple loading text
        style: TextStyle(
          fontSize: 18,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}
