import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/ui/profile_screen/models/club_member_model.dart';

// current user notifier provider
final currentUserNotifierProvider =
    StateNotifierProvider<CurrentUserNotifier, ClubMemberModel?>(
        (ref) => CurrentUserNotifier());

class CurrentUserNotifier extends StateNotifier<ClubMemberModel?> {
  CurrentUserNotifier() : super(null);

  // update current user
  void updateUser(ClubMemberModel? user) => state = user;

  // reset current user
  void resetUser() => state = null;
}
