import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rotaract/_core/extensions/color_extension.dart';
import 'package:rotaract/_core/ui/profile_screen/models/club_member_model.dart';
import 'package:rotaract/discover/ui/members_tab_screen/widgets/info_row.dart';
import 'package:rotaract/discover/ui/members_tab_screen/widgets/skill_chip.dart';

class MembershipInfo extends ConsumerWidget {
  final ClubMemberModel member;
  const MembershipInfo({super.key, required this.member});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.blue.withAlphaa(0.05),
            Colors.indigo.withAlphaa(0.05),
          ],
        ),
        border: Border.all(
          color: Colors.blue.withAlphaa(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withAlphaa(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.card_membership_outlined,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Membership Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (member.joinedDate != null)
            InfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'Member Since',
              value: DateFormat('MMMM dd, yyyy').format(member.joinedDate!),
            ),
          if (member.previousRoles?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Text(
              'Previous Roles',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: member.previousRoles!
                  .map((role) =>
                      SkillChip(label: role, accentColor: Colors.grey))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
