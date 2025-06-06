import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/club_tab_notifier.dart';
import 'package:rotaract/_core/shared_widgets/error_screen_widget.dart';
import 'package:rotaract/_core/shared_widgets/loading_screen_widget.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/club_app_bar_widget.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/quick_actions_widget.dart';

import 'package:rotaract/admin_tools/repos/club_repo_providers.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/stats_section_widget.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/tab_section_widget.dart';

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
    _tabController = TabController(length: 4, vsync: this);
    _scrollController.addListener(_onScroll);
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
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clubByIdProv = ref.watch(getClubByIdProvider);
    _tabController.index = ref.read(clubTabIndexProvider);
    return clubByIdProv.when(
      data: (club) {
        if (club == null) {
          return const ErrorScreenWidget(
            error: "Club not found",
          );
        }
        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              ClubAppBarWidget(
                club: club,
                isScrolled: _isScrolled,
              ),
              QuickActionsWidget(club: club),
              const StatsSectionWidget(),
              TabSectionWidget(controller: _tabController),
            ],
          ),
        );
      },
      error: (error, stack) {
        return const ErrorScreenWidget(
          error: "Failed to load club information",
        );
      },
      loading: () => const LoadingScreenWidget(),
    );
  }
}
