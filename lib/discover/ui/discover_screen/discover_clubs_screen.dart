import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/_core/providers/auth_provider.dart';
import 'package:rotaract/_core/shared_widgets/modern_app_bar_widget.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/clubs_tab_widget.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/discover_stats_widget.dart';
import 'package:rotaract/discover/ui/events_screen/events_screen.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/news_tab_widget.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/projects_tab_widget.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/search_bar_widget.dart';

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
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(watchCurrentUserProvider, (_, next) {
      next.whenData(
        (value) {
          ref.read(currentUserNotifierProvider.notifier).updateUser(value);
        },
      );
    });
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          const ModernAppBarWidget(
            title: "Discover",
            subtitle: "Find clubs, events, and opportunities",
          ),
          const SearchBarWidget(),
          _buildCategoriesSection(),
        ],
        body: TabBarView(
          controller: _tabController,
          children: const [
            ClubsTabWidget(),
            EventsScreen(),
            ProjectsTabWidget(),
            NewsTabWidget(),
          ],
        ),
      ),
      // floatingActionButton:
      //     //     // const AddClubWidget()

      //     FloatingActionButton(
      //   onPressed: () {
      //     final event = ClubEventModel(
      //       id: const Uuid().v4(),
      //       title: "Presidential Installation",
      //       location: "Chagos Country Resort, Kasangati Kira Rd",
      //       clubId: "f95c1eec-f50a-4d08-9dad-5e6734326d8e",
      //       imageUrl:
      //           "https://firebasestorage.googleapis.com/v0/b/rotaract-584b8.firebasestorage.app/o/EVENTS%2FWhatsApp%20Image%202025-05-30%20at%2011.56.43%20(2).jpeg?alt=media&token=402dd230-0300-4d84-9e4b-70c309d90e29",
      //       startDate: DateTime(2025, 07, 12),
      //       endDate: DateTime(2025, 07, 12),
      //     );

      //     ref
      //         .read(clubEventsControllerProvider.notifier)
      //         .addEvent(event: event);
      //   },
      //   backgroundColor: Colors.purple.shade600,
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
    );
  }

  Widget _buildCategoriesSection() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          const DiscoverStatsWidget(),
          const SizedBox(height: 20),
          _buildTabBar(),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: "Clubs"),
          Tab(text: "Events"),
          Tab(text: "Projects"),
          Tab(text: "News"),
        ],
        labelColor: Colors.purple.shade600,
        unselectedLabelColor: Colors.grey.shade600,
        indicatorColor: Colors.purple.shade600,
        indicatorWeight: 3,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }
}
