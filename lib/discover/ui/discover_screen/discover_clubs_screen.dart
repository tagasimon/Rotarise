import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/discover_tab_index_notifier.dart';
import 'package:rotaract/_core/shared_widgets/modern_app_bar_widget.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/clubs_tab_widget.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/projects_tab_widget.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/search_bar_widget.dart';
import 'package:rotaract/discover/ui/events_screen/events_screen.dart';

class DiscoverClubsScreen extends ConsumerStatefulWidget {
  const DiscoverClubsScreen({super.key});

  @override
  ConsumerState<DiscoverClubsScreen> createState() =>
      _DiscoverClubsScreenState();
}

class _DiscoverClubsScreenState extends ConsumerState<DiscoverClubsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final initialIndex = ref.read(discoverTabIndexProvider);
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: initialIndex,
    );

    // Listen to tab changes and update Riverpod state
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    // Only update if the tab actually changed to avoid unnecessary rebuilds
    if (!_tabController.indexIsChanging) {
      final currentIndex = ref.read(discoverTabIndexProvider);
      if (_tabController.index != currentIndex) {
        ref
            .read(discoverTabIndexProvider.notifier)
            .setTabIndex(_tabController.index);
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to Riverpod state changes and update TabController accordingly
    ref.listen<int>(discoverTabIndexProvider, (previous, next) {
      if (_tabController.index != next) {
        _tabController.animateTo(next);
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            const ModernAppBarWidget(
              title: "Discover",
              subtitle: "Find clubs, events, and opportunities",
            ),
            const SearchBarWidget(),
            const SliverToBoxAdapter(
              child: Column(
                children: [
                  // TODO Add Club Stats
                  // DiscoverStatsWidget(),
                  // SizedBox(height: 20),
                ],
              ),
            ),
            // Pinned TabBar that stays visible
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyTabBarDelegate(
                tabBar: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Clubs'),
                    Tab(text: 'Events'),
                    Tab(text: 'Projects'),
                  ],
                  indicatorColor: Theme.of(context).primaryColor,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          physics: const BouncingScrollPhysics(),
          children: const [
            ClubsTabWidget(),
            EventsScreen(),
            ProjectsTabWidget(),
          ],
        ),
      ),
    );
  }
}

// Custom delegate for sticky tab bar
class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _StickyTabBarDelegate({required this.tabBar});

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
