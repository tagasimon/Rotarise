import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/discover_tab_index_notifier.dart';
import 'package:rotaract/admin_tools/providers/club_repo_providers.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/stat_card_widget.dart';

class ClubsCountWidget extends ConsumerWidget {
  const ClubsCountWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countProv = ref.watch(getTotalClubsCountProvider);
    return GestureDetector(
      onTap: () {
        ref.read(discoverTabIndexProvider.notifier).setTabIndex(0);
      },
      child: countProv.when(data: (count) {
        return StatCardWidget(
            number: "$count",
            label: "Clubs",
            icon: Icons.groups_outlined,
            color: Colors.blue.shade400);
      }, error: (e, s) {
        debugPrint("Error $e, $s");
        return StatCardWidget(
            number: "_",
            label: "Clubs",
            icon: Icons.groups_outlined,
            color: Colors.blue.shade400);
      }, loading: () {
        return StatCardWidget(
            number: "...",
            label: "Clubs",
            icon: Icons.groups_outlined,
            color: Colors.blue.shade400);
      }),
    );
  }
}
