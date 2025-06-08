import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rotaract/_core/notifiers/club_tab_notifier.dart';
import 'package:rotaract/_core/shared_widgets/error_screen_widget.dart';
import 'package:rotaract/_core/shared_widgets/loading_screen_widget.dart';
import 'package:rotaract/admin_tools/providers/club_repo_providers.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/club_about_widget.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/club_app_bar_widget.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/club_events_widget.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/quick_actions_widget.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/stats_section_widget.dart';
import 'package:rotaract/discover/ui/members_tab_screen/club_members_screen.dart';

class ClubHomeScreen extends ConsumerStatefulWidget {
  const ClubHomeScreen({super.key});

  @override
  ConsumerState<ClubHomeScreen> createState() => _ClubHomeScreenState();
}

class _ClubHomeScreenState extends ConsumerState<ClubHomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    // Initialize TabController with the current state from Riverpod
    final initialIndex = ref.read(clubTabIndexProvider);
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: initialIndex,
    );

    // Listen to tab changes and update Riverpod state
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_onScroll);
  }

  void _onTabChanged() {
    // Only update if the tab actually changed to avoid unnecessary rebuilds
    if (!_tabController.indexIsChanging) {
      final currentIndex = ref.read(clubTabIndexProvider);
      if (_tabController.index != currentIndex) {
        ref
            .read(clubTabIndexProvider.notifier)
            .setTabIndex(_tabController.index);
      }
    }
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 200 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clubByIdProv = ref.watch(getClubByIdProvider);

    // Listen to Riverpod state changes and update TabController accordingly
    ref.listen<int>(clubTabIndexProvider, (previous, next) {
      if (_tabController.index != next) {
        _tabController.animateTo(next);
      }
    });

    return clubByIdProv.when(
      data: (club) {
        if (club == null) {
          return const ErrorScreenWidget(error: "Club not found");
        }
        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          body: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                ClubAppBarWidget(
                  club: club,
                  isScrolled: _isScrolled,
                ),
                QuickActionsWidget(club: club),
                const StatsSectionWidget(),
                // Pinned TabBar that stays visible
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyTabBarDelegate(
                    tabBar: TabBar(
                      controller: _tabController,
                      tabs: const [
                        // Tab(text: 'Posts'),
                        Tab(text: 'Members'),
                        Tab(text: 'Events'),
                        Text("Projects"),
                        Tab(text: 'About'),
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
              children: const [
                // Posts Tab Content
                // _buildTabContent('Posts'),
                ClubMembersScreen(),
                ClubEventsWidget(),
                Center(child: Text("Projects")),
                ClubAboutWidget()
              ],
            ),
          ),
        );
      },
      error: (error, stack) {
        debugPrint("Error: $error, Stack: $stack");
        return const ErrorScreenWidget(
            error: "Failed to load club information");
      },
      loading: () => const LoadingScreenWidget(),
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
