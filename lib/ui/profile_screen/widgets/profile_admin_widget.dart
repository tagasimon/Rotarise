import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileAdminWidget extends ConsumerWidget {
  const ProfileAdminWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final auth = ref.watch(firebaseAuthInstanceProvider);
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
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 30.0,
              child: ClipOval(child: Image.asset("assets/images/logo.png")),
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Administrator",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("simeone@kanos.club"),
                ],
              ),
            ),
            const Spacer(),
            // const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
