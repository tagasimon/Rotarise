import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/ui/profile_screen/models/club_member_model.dart';
import 'package:rotaract/admin_tools/ui/club_members/widgets/member_detail_row.dart';

class MemberDetailsContent extends ConsumerWidget {
  final ClubMemberModel member;
  const MemberDetailsContent({super.key, required this.member});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (member.imageUrl != null) ...[
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(member.imageUrl!),
            ),
          ),
          const SizedBox(height: 16),
        ],
        MemberDetailRow(label: 'Email', value: member.email ?? 'Not provided'),
        MemberDetailRow(
            label: 'Phone', value: member.phoneNumber ?? 'Not provided'),
        MemberDetailRow(
            label: 'Gender', value: member.gender ?? 'Not specified'),
        MemberDetailRow(
            label: 'Profession', value: member.profession ?? 'Not specified'),
        MemberDetailRow(
            label: 'Company', value: member.company ?? 'Not specified'),
        MemberDetailRow(
            label: 'Job Title', value: member.jobTitle ?? 'Not specified'),
        MemberDetailRow(
            label: 'Current Role', value: member.currentClubRole ?? 'Member'),
        MemberDetailRow(
            label: 'Address', value: member.address ?? 'Not provided'),
        if (member.expertise != null && member.expertise!.isNotEmpty)
          MemberDetailRow(
              label: 'Expertise', value: member.expertise!.join(', ')),
        if (member.education != null && member.education!.isNotEmpty)
          MemberDetailRow(
              label: 'Education', value: member.education!.join(', ')),
        if (member.dateOfBirth != null)
          MemberDetailRow(
            label: 'Date of Birth',
            value:
                '${member.dateOfBirth!.day}/${member.dateOfBirth!.month}/${member.dateOfBirth!.year}',
          ),
        if (member.joinedDate != null)
          MemberDetailRow(
            label: 'Joined Date',
            value:
                '${member.joinedDate!.day}/${member.joinedDate!.month}/${member.joinedDate!.year}',
          ),
      ],
    );
  }
}
