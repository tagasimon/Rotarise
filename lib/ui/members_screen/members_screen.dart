import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/providers/members_repo_provider.dart';
import 'package:rotaract/ui/members_screen/widgets/member_item_widget.dart';

class MembersScreen extends ConsumerWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersListProv = ref.watch(membersListProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'CLUB OFFICERS',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: membersListProv.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(
              child: Text("No Members.."),
            );
          }
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color:
                    const Color(0xFFFFAA00), // Orange color matching app theme
                child: const Column(
                  children: [
                    Text(
                      'Board & Offiers RY 2025/2026',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return MemberItemWidget(member: data[index]);
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          debugPrint("Error loading members: $error, $stack");
          return const Center(
            child: Text(
              'Error loading nutritionists',
              style: TextStyle(color: Colors.red),
            ),
          );
        },
      ),
    );
  }
}
