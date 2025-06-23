// members_data_table.dart
import 'package:flutter/material.dart';
import 'package:rotaract/_core/shared_widgets/circle_image_widget.dart';
import 'package:rotaract/_core/ui/profile_screen/models/club_member_model.dart';
import 'package:rotaract/admin_tools/ui/club_members/widgets/member_action_cell.dart';

class MembersDataTable extends StatelessWidget {
  final List<ClubMemberModel> members;
  final int sortColumnIndex;
  final bool sortAscending;
  final Function(int, bool) onSort;

  const MembersDataTable({
    super.key,
    required this.members,
    required this.sortColumnIndex,
    required this.sortAscending,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      sortColumnIndex: sortColumnIndex,
      sortAscending: sortAscending,
      columns: [
        DataColumn(
          label:
              const Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
          onSort: onSort,
        ),
        DataColumn(
          label: const Text('Email',
              style: TextStyle(fontWeight: FontWeight.bold)),
          onSort: onSort,
        ),
        DataColumn(
          label:
              const Text('Role', style: TextStyle(fontWeight: FontWeight.bold)),
          onSort: onSort,
        ),
        DataColumn(
          label: const Text('Profession',
              style: TextStyle(fontWeight: FontWeight.bold)),
          onSort: onSort,
        ),
        DataColumn(
          label: const Text('Joined Date',
              style: TextStyle(fontWeight: FontWeight.bold)),
          onSort: onSort,
        ),
        const DataColumn(
          label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
      rows:
          members.map((member) => MemberDataRowBuilder.build(member)).toList(),
    );
  }
}

// member_data_row.dart
class MemberDataRowBuilder {
  static DataRow build(ClubMemberModel member) {
    return DataRow(
      cells: [
        DataCell(MemberNameCell(member: member)),
        DataCell(MemberEmailCell(member: member)),
        DataCell(MemberRoleCell(member: member)),
        DataCell(MemberProfessionCell(member: member)),
        DataCell(MemberJoinedDateCell(member: member)),
        DataCell(MemberActionsCell(member: member)),
      ],
    );
  }
}

// member_name_cell.dart
class MemberNameCell extends StatelessWidget {
  final ClubMemberModel member;

  const MemberNameCell({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        member.imageUrl != null
            ? CircleImageWidget(
                imageUrl: member.imageUrl!,
                size: 40,
              )
            : CircleAvatar(
                radius: 16,
                child: Text(
                  '${member.firstName[0]}${member.lastName[0]}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            '${member.firstName} ${member.lastName}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// member_email_cell.dart
class MemberEmailCell extends StatelessWidget {
  final ClubMemberModel member;

  const MemberEmailCell({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      member.email ?? 'No email',
      style: TextStyle(
        color: member.email != null ? null : Colors.grey,
      ),
    );
  }
}

// member_role_cell.dart
class MemberRoleCell extends StatelessWidget {
  final ClubMemberModel member;

  const MemberRoleCell({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getRoleColor(member.currentClubRole),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        member.currentClubRole ?? 'Member',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getRoleColor(String? role) {
    switch (role?.toLowerCase()) {
      case 'president':
        return Colors.purple;
      case 'secretary':
        return Colors.blue;
      case 'treasurer':
        return Colors.green;
      case 'vice president':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

// member_profession_cell.dart
class MemberProfessionCell extends StatelessWidget {
  final ClubMemberModel member;

  const MemberProfessionCell({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      member.profession ?? 'Not specified',
      style: TextStyle(
        color: member.profession != null ? null : Colors.grey,
      ),
    );
  }
}

// member_joined_date_cell.dart
class MemberJoinedDateCell extends StatelessWidget {
  final ClubMemberModel member;

  const MemberJoinedDateCell({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      member.joinedDate != null
          ? '${member.joinedDate!.day}/${member.joinedDate!.month}/${member.joinedDate!.year}'
          : 'Not specified',
      style: TextStyle(
        color: member.joinedDate != null ? null : Colors.grey,
      ),
    );
  }
}
