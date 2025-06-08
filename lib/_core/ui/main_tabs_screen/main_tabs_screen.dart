import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/tab_index_notifier.dart';
import 'package:rotaract/admin_tools/news_feed/news_feed_screen/news_feed_screen.dart';

import 'package:rotaract/discover/ui/discover_screen/discover_clubs_screen.dart';
import 'package:rotaract/_core/ui/profile_screen/ui/profile_screen/profile_screen.dart';

class MainTabsScreen extends ConsumerStatefulWidget {
  const MainTabsScreen({super.key});

  @override
  ConsumerState<MainTabsScreen> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends ConsumerState<MainTabsScreen>
    with TickerProviderStateMixin {
  final _screens = [
    const NewsFeedScreen(),
    const DiscoverClubsScreen(),
    const ProfileScreen(),
  ];

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    _animationController.forward().then((_) {
      ref.read(tabIndexProvider.notifier).setTabIndex(index);
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabIndex = ref.watch(tabIndexProvider);
    final theme = Theme.of(context);

    return Scaffold(
      extendBody: true,
      body: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: _screens[tabIndex],
          );
        },
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: theme.primaryColor.withOpacity(0.1),
              blurRadius: 40,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.1),
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
            animationDuration: const Duration(milliseconds: 600),
            indicatorColor: theme.primaryColor.withOpacity(0.15),
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            destinations: [
              _buildModernDestination(
                index: 0,
                currentIndex: tabIndex,
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: "Feed",
                primaryColor: theme.primaryColor,
              ),
              _buildModernDestination(
                index: 1,
                currentIndex: tabIndex,
                icon: Icons.explore_outlined,
                selectedIcon: Icons.explore,
                label: "Discover",
                primaryColor: theme.primaryColor,
              ),
              _buildModernDestination(
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
      ),
    );
  }

  NavigationDestination _buildModernDestination({
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
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color:
              isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(
              scale: animation,
              child: RotationTransition(
                turns: animation,
                child: child,
              ),
            );
          },
          child: Icon(
            isSelected ? selectedIcon : icon,
            key: ValueKey(isSelected),
            color: isSelected ? primaryColor : Colors.grey.shade600,
            size: isSelected ? 28 : 24,
          ),
        ),
      ),
      selectedIcon: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: primaryColor.withOpacity(0.15),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          selectedIcon,
          color: primaryColor,
          size: 28,
        ),
      ),
    );
  }
}
