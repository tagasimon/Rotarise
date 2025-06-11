import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_constants/constants.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/_core/shared_widgets/circle_image_widget.dart';

class ProfileAdminWidget extends ConsumerWidget {
  const ProfileAdminWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cMember = ref.watch(currentUserNotifierProvider);
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade400, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ProfessionalCircleImageWidget(
              imageUrl: cMember?.imageUrl ?? Constants.kDefaultImageLink,
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${cMember?.firstName} ${cMember?.lastName}",
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("${cMember?.email}"),
                ],
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_right_outlined),
          ],
        ),
      ),
    );
  }
}
