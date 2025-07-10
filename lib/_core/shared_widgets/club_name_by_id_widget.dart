import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/extensions/nav_ext.dart';
import 'package:rotaract/_core/notifiers/selected_club_notifier.dart';
import 'package:rotaract/admin_tools/providers/club_repo_providers.dart';
import 'package:rotaract/discover/ui/club_home_screen/club_home_screen.dart';

class ClubNameByIdWidget extends ConsumerWidget {
  final String clubId;
  final TextStyle? style;
  const ClubNameByIdWidget({
    super.key,
    required this.clubId,
    this.style,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubInfoProv = ref.watch(getEventClubByIdProvider(clubId));
    return clubInfoProv.when(
      data: (club) {
        return GestureDetector(
          onTap: () {
            ref.read(selectedClubNotifierProvider.notifier).updateClub(club);
            context.push(const ClubHomeScreen());
          },
          child: Text(
            club!.name,
            style: style ??
                const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
          ),
        );
      },
      loading: () => const Text("..."),
      error: (e, s) {
        debugPrint("Error $e, $s");
        return Text('Error: $e');
      },
    );
  }
}
