import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/core/extensions/extensions.dart';
import 'package:rotaract/features/clubs/models/club_model.dart';
import 'package:rotaract/features/clubs/presentation/screens/club_main_screen.dart';

class ClubItemWidget extends ConsumerWidget {
  final ClubModel club;
  const ClubItemWidget({super.key, required this.club});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.push(ClubMainScreen(id: club.id)),
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(radius: 50, child: Text(club.name[0])),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(club.name,
                      style: Theme.of(context).textTheme.labelLarge),
                  Text(club.phone ?? "No phone number"),
                  Text(club.email ?? "No email"),
                  Text(club.meetingTime ?? "No meeting time"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
