import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/admin_tools/repos/club_repo_providers.dart';

class ClubAboutWidget extends ConsumerWidget {
  final String id;
  const ClubAboutWidget({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubProv = ref.watch(getClubByIdProvider(id));
    return clubProv.when(
      data: (data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data?.description ?? "No about"),
            const SizedBox(height: 8),
            Text(data?.meetingTime ?? "No meeting time"),
            const SizedBox(height: 8),
            Text(data?.meetingLocation ?? "No meeting location"),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, _) => Text(error.toString()),
    );
  }
}
