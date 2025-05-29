import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/models/member_model.dart';

// current user notifier provider
final currentUserNotifierProvider =
    StateNotifierProvider<CurrentUserNotifier, MemberModel?>(
        (ref) => CurrentUserNotifier());

class CurrentUserNotifier extends StateNotifier<MemberModel?> {
  CurrentUserNotifier() : super(null);

  // update current user
  void updateUser(MemberModel? user) => state = user;

  // reset current user
  void resetUser() => state = null;
}
