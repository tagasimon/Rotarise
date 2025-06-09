import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/providers/auth_provider.dart';
import 'package:rotaract/discover/ui/members_tab_screen/widgets/member_detail_sheet.dart';

class MemberByIdWidget extends ConsumerWidget {
  final String memberId;
  const MemberByIdWidget({super.key, required this.memberId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfoProv = ref.watch(watchUserInfoProvider(memberId));
    return userInfoProv.when(
      data: (user) {
        return MemberDetailSheet(
          member: user,
          isProfileScreen: true,
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, s) => Text('Error: $e'),
    );
  }
}
