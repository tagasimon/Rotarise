import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';

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
            // TODO : Add a profile picture
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 30.0,
              child: ClipOval(
                child: cMember?.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: cMember!.imageUrl!,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                          size: 60.0,
                          color: Colors.red,
                        ),
                        fit: BoxFit.cover,
                        width: 60.0,
                        height: 60.0,
                      )
                    : const Icon(
                        Icons.person,
                        size: 60.0,
                        color: Colors.grey,
                      ),
              ),
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
