import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/shared_widgets/modern_app_bar_widget.dart';
import 'package:rotaract/admin_tools/ui/add_club/add_club_widget.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/clubs_tab_widget.dart';
import 'package:rotaract/discover/ui/events_screen/controllers/club_events_controller.dart';
import 'package:rotaract/discover/ui/events_screen/events_screen.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/news_tab_widget.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/projects_tab_widget.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/search_bar_widget.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/stats_widget.dart';
import 'package:rotaract/discover/ui/events_screen/models/club_event_model.dart';
import 'package:uuid/uuid.dart';

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
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          const ModernAppBarWidget(
              title: "Discover",
              subtitle: "Find clubs, events, and opportunities"),
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
      floatingActionButton:
          // const AddClubWidget()

          FloatingActionButton(
        onPressed: () {
          // final event = ClubEventModel(
          //   id: const Uuid().v4(),
          //   title: "One on One with President Elect",
          //   location: "People's Medical Hospital",
          //   clubId: "f95c1eec-f50a-4d08-9dad-5e6734326d8e",
          //   imageUrl:
          //       "https://firebasestorage.googleapis.com/v0/b/rotaract-584b8.firebasestorage.app/o/EVENTS%2FGrsifEuW0AEPtss.jpeg?alt=media&token=6ff59f80-278d-476a-89bf-8f4e577cc7ca",
          //   startDate: DateTime(2025, 05, 25),
          //   endDate: DateTime(2025, 05, 25),
          // );

          // ref
          //     .read(clubEventsControllerProvider.notifier)
          //     .addEvent(event: event);
        },
        backgroundColor: Colors.purple.shade600,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Widget _buildModernAppBar(BuildContext context) {
  //   return SliverAppBar(
  //     expandedHeight: 120,
  //     floating: true,
  //     snap: true,
  //     elevation: 0,
  //     backgroundColor: Colors.white,
  //     surfaceTintColor: Colors.transparent,
  //     flexibleSpace: FlexibleSpaceBar(
  //       background: Container(
  //         decoration: BoxDecoration(
  //           gradient: LinearGradient(
  //             begin: Alignment.topLeft,
  //             end: Alignment.bottomRight,
  //             colors: [
  //               Colors.purple.shade400,
  //               Colors.blue.shade400,
  //             ],
  //           ),
  //         ),
  //         child: SafeArea(
  //           child: Padding(
  //             padding: const EdgeInsets.all(20),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Text(
  //                   "Discover",
  //                   style: TextStyle(
  //                     fontSize: 32,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Text(
  //                   "Find clubs, events, and opportunities",
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     color: Colors.white.withOpacity(0.9),
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildCategoriesSection() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          const StatsWidget(),
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
