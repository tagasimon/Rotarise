import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/_core/notifiers/discover_tab_index_notifier.dart';
import 'package:rotaract/_core/providers/auth_provider.dart';
import 'package:rotaract/_core/shared_widgets/modern_app_bar_widget.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/clubs_tab_widget.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/discover_stats_widget.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/discover_tab_bar.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/news_tab_widget.dart';
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
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO Find another spot to listen to the current user
    ref.listen<AsyncValue>(watchCurrentUserProvider, (_, next) {
      next.whenData(
        (value) {
          ref.read(currentUserNotifierProvider.notifier).updateUser(value);
        },
      );
    });
    _tabController.index = ref.read(discoverTabIndexProvider);
    // final state = ref.watch(clubControllerProvider);
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          const ModernAppBarWidget(
            title: "Discover",
            subtitle: "Find clubs, events, and opportunities",
          ),
          const SearchBarWidget(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const DiscoverStatsWidget(),
                const SizedBox(height: 20),
                DiscoverTabBar(tabController: _tabController),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          physics: const BouncingScrollPhysics(),
          children: const [
            ClubsTabWidget(),
            EventsScreen(),
            ProjectsTabWidget(),
            NewsTabWidget(),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: state.isLoading
      //       ? null
      //       : () async {
      //           final rawData = await rootBundle
      //               .loadString('assets/csv/rotaractd9213.csv');
      //           List<List<dynamic>> csvData =
      //               const CsvToListConverter().convert(rawData);

      //           for (var row in csvData) {
      //             final clubImg = row[1].toString().trim();
      //             final clubName = row[2].toString().trim();

      //             final club = ClubModel(
      //               id: const Uuid().v4(),
      //               name: clubName,
      //               imageUrl: clubImg,
      //               coverImageUrl: clubImg,
      //               isVerified: true,
      //               createdAt: DateTime.now(),
      //             );
      //             print(club);
      //             await ref
      //                 .read(clubControllerProvider.notifier)
      //                 .addClub(club);
      //           }

      //           // Example: Print the map
      //         },
      //   child: state.isLoading
      //       ? const CircularProgressIndicator(color: Colors.white)
      //       : const Icon(Icons.add, color: Colors.red),
      // )
      //  const AddClubWidget()
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
}
