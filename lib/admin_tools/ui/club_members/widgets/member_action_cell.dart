// member_actions_cell.dart
import 'package:flutter/material.dart';
import 'package:rotaract/_core/ui/profile_screen/models/club_member_model.dart';

class MemberActionsCell extends StatelessWidget {
  final ClubMemberModel member;

  const MemberActionsCell({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, size: 18),
          onPressed: () {},
          tooltip: 'Edit Member',
        ),
        IconButton(
          icon: const Icon(Icons.visibility, size: 18),
          onPressed: () {},
          tooltip: 'View Details',
        ),
        IconButton(
          icon: const Icon(Icons.delete, size: 18, color: Colors.red),
          onPressed: () {
            // Implement remove from club
          },
          tooltip: 'Delete Member',
        ),
      ],
    );
  }
}
