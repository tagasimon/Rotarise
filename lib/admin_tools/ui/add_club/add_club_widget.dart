import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddClubWidget extends ConsumerWidget {
  const AddClubWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {
        // String randomNameGenerator() {
        //   // return a random name
        //   return "Rotaract Club of ${const Uuid().v4().split("-").first}";
        // }

        // final club = ClubModel(
        //     id: const Uuid().v4(),
        //     name: "Rotaract club of bweyogerere namboole",
        //     nickName: "Destadia",
        //     isVerified: true,
        //     imageUrl:
        //         "https://firebasestorage.googleapis.com/v0/b/rotaract-584b8.firebasestorage.app/o/EVENTS%2Fdestadia.jpg?alt=media&token=df75e4f1-154b-49e2-990b-22155adf707f",
        //     coverImageUrl:
        //         "https://firebasestorage.googleapis.com/v0/b/rotaract-584b8.firebasestorage.app/o/EVENTS%2FXavier-Ssentamu-Bweyogerere-Namboole-August-2024.jpg?alt=media&token=b453ad3a-a3c5-477e-b1a0-720697c3a18c");

        // ref.read(clubControllerProvider.notifier).addClub(club);
      },
      child: const Icon(Icons.add),
    );
  }
}
