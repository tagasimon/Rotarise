import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/features/auth/models/user_model.dart';

// current user notifier provider
final currentUserNotifierProvider =
    StateNotifierProvider<CurrentUserNotifier, UserModel?>(
        (ref) => CurrentUserNotifier());

class CurrentUserNotifier extends StateNotifier<UserModel?> {
  CurrentUserNotifier() : super(null);

  // update current user
  void updateUser(UserModel? user) => state = user;

  // reset current user
  void resetUser() => state = null;
}
