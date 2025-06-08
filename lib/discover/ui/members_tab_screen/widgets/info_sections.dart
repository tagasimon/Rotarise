import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/ui/profile_screen/models/club_member_model.dart';
import 'package:rotaract/discover/ui/members_tab_screen/widgets/info_card.dart';
import 'package:rotaract/discover/ui/members_tab_screen/widgets/info_row.dart';
import 'package:rotaract/discover/ui/members_tab_screen/widgets/membership_info.dart';
import 'package:rotaract/discover/ui/members_tab_screen/widgets/skills_card.dart';

class InfoSections extends ConsumerWidget {
  final ClubMemberModel member;
  final bool isDark;
  const InfoSections({super.key, required this.member, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (member.profession?.isNotEmpty == true)
          InfoCard(
            title: 'Professional Information',
            accentColor: Colors.green,
            isDark: isDark,
            children: [
              InfoRow(
                icon: Icons.work_outline,
                label: 'Profession',
                value: member.profession!,
              ),
              if (member.company?.isNotEmpty == true)
                InfoRow(
                  icon: Icons.business_outlined,
                  label: 'Company',
                  value: member.company!,
                ),
              if (member.jobTitle?.isNotEmpty == true)
                InfoRow(
                  icon: Icons.badge_outlined,
                  label: 'Job Title',
                  value: member.jobTitle!,
                ),
            ],
          ),
        const SizedBox(height: 20),
        if (member.email?.isNotEmpty == true ||
            member.phoneNumber?.isNotEmpty == true)
          InfoCard(
            title: 'Contact Information',
            accentColor: Colors.orange,
            isDark: isDark,
            children: [
              if (member.email?.isNotEmpty == true)
                InfoRow(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: member.email!,
                ),
              if (member.phoneNumber?.isNotEmpty == true)
                InfoRow(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: member.phoneNumber!,
                ),
              if (member.address?.isNotEmpty == true)
                InfoRow(
                  icon: Icons.location_on_outlined,
                  label: 'Address',
                  value: member.address!,
                ),
            ],
          ),
        const SizedBox(height: 20),
        if (member.expertise?.isNotEmpty == true)
          SkillsCard(
            title: 'Areas of Expertise',
            items: member.expertise!,
            accentColor: Colors.purple,
            isDark: isDark,
          ),
        const SizedBox(height: 20),
        if (member.education?.isNotEmpty == true)
          SkillsCard(
            title: 'Education',
            items: member.education!,
            accentColor: Colors.teal,
            isDark: isDark,
          ),
        const SizedBox(height: 20),
        MembershipInfo(member: member),
      ],
    );
  }
}
