// totalMembersByClubIdProvider

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/ui/profile_screen/providers/members_repo_provider.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/stat_card_widget.dart';

class MembersByClubCountWidget extends ConsumerWidget {
  const MembersByClubCountWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countProv = ref.watch(totalMembersByClubIdProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: countProv.when(
          data: (count) {
            return StatCardWidget(
                number: "$count",
                label: "Members",
                icon: Icons.group,
                color: Colors.purple.shade400);
          },
          error: (e, s) => const Text("Error fetching members count"),
          loading: () {
            return StatCardWidget(
                number: "...",
                label: "Members",
                icon: Icons.group,
                color: Colors.purple.shade400);
          }),
    );
  }
}
