// manage_club_members_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/ui/profile_screen/providers/members_repo_provider.dart';
import 'package:rotaract/admin_tools/ui/club_members/widgets/members_data_view.dart';
import 'package:rotaract/admin_tools/ui/club_members/widgets/members_error_view.dart';
import 'package:rotaract/admin_tools/ui/club_members/widgets/members_search_bar.dart';

class ManageClubMembersScreen extends ConsumerStatefulWidget {
  const ManageClubMembersScreen({super.key});

  @override
  ConsumerState<ManageClubMembersScreen> createState() =>
      _ManageClubMembersScreenState();
}

class _ManageClubMembersScreenState
    extends ConsumerState<ManageClubMembersScreen> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
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
      appBar: AppBar(
        title: const Text('Club Members'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(clubMembersListByClubIdProvider),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          MembersSearchBar(
            controller: _searchController,
            searchQuery: _searchQuery,
            onSearchChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
            onClear: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
              });
            },
          ),
          Expanded(
            child: membersListProv.when(
              data: (members) {
                return MembersDataView(
                  members: members,
                  searchQuery: _searchQuery,
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending,
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                    });
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => MembersErrorView(
                error: error,
                onRetry: () => ref.refresh(clubMembersListByClubIdProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
