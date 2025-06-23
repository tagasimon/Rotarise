import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/_core/providers/firebase_providers.dart';
import 'package:rotaract/admin_tools/models/club_role.dart';
import 'package:rotaract/admin_tools/repos/roles_repo.dart';

final clubRolesRepoProvider = Provider<RolesRepo>((ref) {
  return RolesRepo(ref.watch(rolesCollectionRefProvider));
});

final roleByIdProvider =
    FutureProvider.family<ClubRole?, String>((ref, roleId) {
  return ref.watch(clubRolesRepoProvider).getRoleById(roleId);
});

// get all roles by club id provider
final rolesByClubIdProvider =
    FutureProvider.autoDispose<List<ClubRole>?>((ref) {
  final cUser = ref.watch(currentUserNotifierProvider);
  if (cUser == null) {
    // return future data with an empty list
    return Future.value([]);
  }
  return ref.watch(clubRolesRepoProvider).getAllClubRoles(cUser.clubId!);
});
