import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/admin_tools/controllers/club_controllers.dart';
import 'package:rotaract/admin_tools/models/club_model.dart';
import 'package:uuid/uuid.dart';

class AddClubWidget extends ConsumerWidget {
  const AddClubWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {
        String randomNameGenerator() {
          // return a random name
          return "Rotaract Club of ${const Uuid().v4().split("-").first}";
        }

        final club = ClubModel(
          id: const Uuid().v4(),
          name: randomNameGenerator(),
          isVerified: true,
        );

        ref.read(clubControllerProvider.notifier).addClub(club);
      },
      child: const Icon(Icons.add),
    );
  }
}
