import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/admin_tools/providers/club_repo_providers.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/club_item_widget.dart';

class ClubsTabWidget extends ConsumerWidget {
  const ClubsTabWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubsProv = ref.watch(getAllVerifiedClubsProvider);
    return clubsProv.when(
      data: (clubs) {
        if (clubs.isEmpty) {
          return _buildEmptyState("No clubs found", Icons.groups_outlined);
        }
        return Container(
          margin: const EdgeInsets.only(top: 20),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: clubs.length,
            itemBuilder: (_, index) {
              return ClubItemWidget(club: clubs[index]);
            },
          ),
        );
      },
      error: (error, stack) => Center(child: Text('Error: $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
