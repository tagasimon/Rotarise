import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/controllers/club_controllers.dart';
import 'package:rotaract/models/club_model.dart';
import 'package:rotaract/providers/club_providers.dart';
import 'package:rotaract/ui/clubs_screen/widgets/club_item_widget.dart';
import 'package:uuid/uuid.dart';

class ClubsScreen extends ConsumerWidget {
  const ClubsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubsProv = ref.watch(getAllVerifiedClubsProvider);
    return clubsProv.when(
      data: (clubs) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: const Text("Discover"),
                floating: true,
                snap: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (c, i) => ClubItemWidget(club: clubs[i]),
                  childCount: clubs.length,
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
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
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, s) {
        log("Error: $e, StackTrace: $s");
        return Scaffold(body: Center(child: Text("Error: $e")));
      },
    );
  }
}
