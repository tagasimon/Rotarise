import 'package:flutter/material.dart';
import 'package:rotaract/_core/ui/profile_screen/models/club_member_model.dart';
import 'package:rotaract/admin_tools/ui/club_members/widgets/empty_members_view.dart';
import 'package:rotaract/admin_tools/ui/club_members/widgets/member_data_table.dart';

class MembersDataView extends StatelessWidget {
  final List<ClubMemberModel> members;
  final String searchQuery;
  final int sortColumnIndex;
  final bool sortAscending;
  final Function(int, bool) onSort;

  const MembersDataView({
    super.key,
    required this.members,
    required this.searchQuery,
    required this.sortColumnIndex,
    required this.sortAscending,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return const EmptyMembersView();
    }

    final filteredMembers = _filterMembers();
    final sortedMembers = _sortMembers(filteredMembers);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: MembersDataTable(
          members: sortedMembers,
          sortColumnIndex: sortColumnIndex,
          sortAscending: sortAscending,
          onSort: onSort,
        ),
      ),
    );
  }

  List<ClubMemberModel> _filterMembers() {
    return members.where((member) {
      if (searchQuery.isEmpty) return true;

      final fullName = '${member.firstName} ${member.lastName}'.toLowerCase();
      final email = member.email?.toLowerCase() ?? '';
      final role = member.currentClubRole?.toLowerCase() ?? '';
      final profession = member.profession?.toLowerCase() ?? '';

      return fullName.contains(searchQuery) ||
          email.contains(searchQuery) ||
          role.contains(searchQuery) ||
          profession.contains(searchQuery);
    }).toList();
  }

  List<ClubMemberModel> _sortMembers(List<ClubMemberModel> membersToSort) {
    membersToSort.sort((a, b) {
      dynamic aValue, bValue;

      switch (sortColumnIndex) {
        case 0:
          aValue = '${a.firstName} ${a.lastName}';
          bValue = '${b.firstName} ${b.lastName}';
          break;
        case 1:
          aValue = a.email ?? '';
          bValue = b.email ?? '';
          break;
        case 2:
          aValue = a.currentClubRole ?? '';
          bValue = b.currentClubRole ?? '';
          break;
        case 3:
          aValue = a.profession ?? '';
          bValue = b.profession ?? '';
          break;
        case 4:
          aValue = a.joinedDate ?? DateTime(1900);
          bValue = b.joinedDate ?? DateTime(1900);
          break;
        default:
          aValue = a.firstName;
          bValue = b.firstName;
      }

      final result = sortAscending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
      return result;
    });

    return membersToSort;
  }
}
