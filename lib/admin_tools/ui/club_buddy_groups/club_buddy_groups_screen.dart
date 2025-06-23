import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/admin_tools/providers/club_buddy_groups_providers.dart';
import 'package:rotaract/admin_tools/ui/club_buddy_groups/widgets/buddy_groups_table.dart';

class ClubBuddyGroupsScreen extends ConsumerWidget {
  const ClubBuddyGroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buddyGroupsAsync = ref.watch(clubBuddyGroupsByClubIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buddy Groups'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: buddyGroupsAsync.when(
        data: (buddyGroups) {
          if (buddyGroups.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.groups_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No buddy groups found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Create your first buddy group to get started!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(clubBuddyGroupsByClubIdProvider);
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              scrollDirection: Axis.vertical,
              child: BuddyGroupsTable(buddyGroups: buddyGroups),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading buddy groups',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(clubBuddyGroupsByClubIdProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
