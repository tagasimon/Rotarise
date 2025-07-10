import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/discover/providers/visits_providers.dart';
import 'package:rotaract/discover/ui/user_meetups_screen/widgets/error_state_widget.dart';
import 'package:rotaract/discover/ui/user_meetups_screen/widgets/visit_content_widget.dart';

class UserMeetupsScreen extends ConsumerWidget {
  const UserMeetupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userVisitsProv = ref.watch(cUserVisitsByUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MY MEETUPS',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: userVisitsProv.when(
        data: (visits) => VisitsContentWidget(visits: visits),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => ErrorStateWidget(error: error.toString()),
      ),
    );
  }
}
