import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/admin_tools/repos/club_repo_providers.dart';

class ClubInfoWidget extends ConsumerWidget {
  final String clubId;
  const ClubInfoWidget({super.key, required this.clubId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubInfoProv = ref.watch(getClubByIdProvider(clubId));
    return clubInfoProv.when(
      data: (club) => Text(
        club!.name,
        style: TextStyle(
          color: Colors.purple.shade600,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
      loading: () => const Text("..."),
      error: (e, s) => Text('Error: $e'),
    );
  }
}
