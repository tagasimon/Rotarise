// manage_club_members_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/shared_widgets/circle_image_widget.dart';
import 'package:rotaract/_core/ui/profile_screen/providers/members_repo_provider.dart';
import 'package:rotaract/admin_tools/ui/club_members/widgets/members_error_view.dart';
import 'package:rotaract/admin_tools/ui/club_members/widgets/members_app_bar.dart';

class ManageClubMembersScreen extends ConsumerStatefulWidget {
  const ManageClubMembersScreen({super.key});

  @override
  ConsumerState<ManageClubMembersScreen> createState() =>
      _ManageClubMembersScreenState();
}

class _ManageClubMembersScreenState
    extends ConsumerState<ManageClubMembersScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final membersListProv = ref.watch(clubMembersListByClubIdProvider);
    return Scaffold(
      appBar: MembersAppBar(
        searchController: _searchController,
        onSearchChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
        onRefresh: () => ref.refresh(clubMembersListByClubIdProvider),
      ),
      body: membersListProv.when(
        data: (members) {
          if (members.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No members found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Filter members based on search query
          final filteredMembers = members.where((member) {
            if (_searchQuery.isEmpty) return true;

            final fullName =
                '${member.firstName} ${member.lastName}'.toLowerCase();
            final email = member.email?.toLowerCase() ?? '';
            final role = member.currentClubRole?.toLowerCase() ?? '';
            final profession = member.profession?.toLowerCase() ?? '';

            return fullName.contains(_searchQuery) ||
                email.contains(_searchQuery) ||
                role.contains(_searchQuery) ||
                profession.contains(_searchQuery);
          }).toList();

          if (filteredMembers.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No members match your search',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredMembers.length,
            itemBuilder: (context, index) {
              final member = filteredMembers[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: member.imageUrl != null
                      ? CircleImageWidget(imageUrl: member.imageUrl!, size: 50)
                      : const CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                  title: Text(
                    '${member.firstName} ${member.lastName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (member.email != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.email,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                member.email!,
                                style: const TextStyle(fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (member.currentClubRole != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.badge,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              member.currentClubRole!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (member.profession != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.work,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                member.profession!,
                                style: const TextStyle(fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => MembersErrorView(
          error: error,
          onRetry: () => ref.refresh(clubMembersListByClubIdProvider),
        ),
      ),
    );
  }
}
