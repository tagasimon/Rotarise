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
          'CLUB MEMBERS',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: membersListProv.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(child: Text("No Members.."));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: data.length,
                  itemBuilder: (_, i) => MemberItemWidget(member: data[i]),
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
