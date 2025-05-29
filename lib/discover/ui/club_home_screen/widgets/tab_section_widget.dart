import 'package:flutter/material.dart';
import 'package:rotaract/admin_tools/models/club_model.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/club_info_card_widget.dart';
import 'package:rotaract/discover/ui/members_tab_screen/club_members_screen.dart';

class TabSectionWidget extends StatelessWidget {
  final ClubModel club;
  final TabController controller;

  const TabSectionWidget(
      {super.key, required this.controller, required this.club});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            TabBar(
              controller: controller,
              tabs: const [
                Tab(text: "POSTS"),
                Tab(text: "EVENTS"),
                Tab(text: "MEMBERS"),
                Tab(text: "INFO"),
              ],
              labelColor: Colors.purple.shade600,
              unselectedLabelColor: Colors.grey.shade600,
              indicatorColor: Colors.purple.shade600,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: TabBarView(
                controller: controller,
                children: [
                  _buildTabContent("No posts yet", Icons.article_outlined),
                  _buildTabContent("No events scheduled", Icons.event_outlined),
                  ClubMembersScreen(clubId: club.id),
                  ClubInfoCardWidget(club: club),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(String message, IconData icon) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
