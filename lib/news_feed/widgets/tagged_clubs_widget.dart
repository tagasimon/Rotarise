import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_constants/constants.dart';
import 'package:rotaract/_core/extensions/nav_ext.dart';
import 'package:rotaract/_core/notifiers/selected_club_notifier.dart';
import 'package:rotaract/_core/shared_widgets/circle_image_widget.dart';
import 'package:rotaract/admin_tools/providers/club_repo_providers.dart';
import 'package:rotaract/discover/ui/club_home_screen/club_home_screen.dart';

class TaggedClubsWidget extends ConsumerWidget {
  final List<String> taggedClubIds;

  const TaggedClubsWidget({
    super.key,
    required this.taggedClubIds,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (taggedClubIds.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: taggedClubIds.map((clubId) {
          final clubAsyncValue = ref.watch(getEventClubByIdProvider(clubId));

          return clubAsyncValue.when(
            data: (club) {
              if (club == null) return const SizedBox.shrink();

              return GestureDetector(
                onTap: () {
                  ref
                      .read(selectedClubNotifierProvider.notifier)
                      .updateClub(club);
                  context.push(const ClubHomeScreen());
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleImageWidget(
                        imageUrl: club.imageUrl ?? Constants.kDefaultImageLink,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        club.name,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Loading...',
                style: TextStyle(fontSize: 12),
              ),
            ),
            error: (_, __) => const SizedBox.shrink(),
          );
        }).toList(),
      ),
    );
  }
}
