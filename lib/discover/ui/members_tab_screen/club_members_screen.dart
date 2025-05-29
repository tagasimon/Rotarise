import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/providers/members_repo_provider.dart';
import 'package:rotaract/discover/ui/members_tab_screen/widgets/member_item_widget.dart';

class ClubMembersScreen extends ConsumerWidget {
  final String clubId;
  const ClubMembersScreen({super.key, required this.clubId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersListProv = ref.watch(membersListByClubIdProvider(clubId));
    return membersListProv.when(
      data: (data) {
        if (data.isEmpty) {
          return const Center(child: Text("No Members.."));
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: data.length,
                itemBuilder: (_, i) => MemberItemWidget(member: data[i]),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) {
        debugPrint("Error loading members: $error, $stack");
        return const Center(
          child: Text(
            'Error loading members',
            style: TextStyle(color: Colors.red),
          ),
        );
      },
    );
  }
}
