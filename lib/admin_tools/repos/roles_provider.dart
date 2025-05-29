import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/admin_tools/models/club_role.dart';
import 'package:rotaract/_core/providers/firebase_providers.dart';
import 'package:rotaract/_core/repos/roles_repo.dart';

final rolesRepoProvider = Provider<RolesRepo>((ref) {
  return RolesRepo(ref.watch(rolesCollectionRefProvider));
});

final roleByIdProvider =
    FutureProvider.family<ClubRole?, String>((ref, roleId) {
  return ref.watch(rolesRepoProvider).getRoleById(roleId);
});

// get all roles by club id provider
final allRolesByClubIdProvider =
    FutureProvider.family<List<ClubRole>?, String>((ref, clubId) {
  return ref.watch(rolesRepoProvider).getAllClubRoles(clubId);
});
