import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/models/member_model.dart';
import 'package:rotaract/ui/members_screen/widgets/member_detail_sheet.dart';

class MemberItemWidget extends ConsumerWidget {
  final MemberModel member;
  const MemberItemWidget({super.key, required this.member});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: () async {
          // Navigate to detailed profile
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => MemberDetailSheet(member: member),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: Icon(Icons.person, size: 40, color: Colors.grey[600]),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.firstName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      member.currentClubRole ?? "",
                      style: const TextStyle(
                        color: Color(0xFFFFAA00),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Proffession: ${member.profession}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'View Profile',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
