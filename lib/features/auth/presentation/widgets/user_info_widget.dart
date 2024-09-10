import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/features/auth/providers/auth_provider.dart';

class UserInfoWidget extends ConsumerWidget {
  final String userId;
  const UserInfoWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfoProv = ref.watch(watchUserInfoProvider(userId));
    return userInfoProv.when(
      data: (user) => Text(user.name ?? 'No Name'),
      loading: () => const CircularProgressIndicator(),
      error: (e, s) => Text('Error: $e'),
    );
  }
}
