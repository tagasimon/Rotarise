import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/admin_tools/repos/club_repo_providers.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/stat_card_widget.dart';

class ClubsCountWidget extends ConsumerWidget {
  const ClubsCountWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countProv = ref.watch(getTotalClubsCountProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: countProv.when(
          data: (count) {
            return StatCardWidget(
                number: "$count",
                label: "Clubs",
                icon: Icons.groups_outlined,
                color: Colors.blue.shade400);
          },
          error: (e, s) => const Text("Error fetching clubs count"),
          loading: () {
            return StatCardWidget(
                number: "...",
                label: "Clubs",
                icon: Icons.groups_outlined,
                color: Colors.blue.shade400);
          }),
    );
  }
}
