import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/providers/firebase_providers.dart';
import 'package:rotaract/admin_tools/models/club_role.dart';
import 'package:rotaract/admin_tools/repos/club_roles_repo.dart';

final clubRolesRepoProvider = Provider<ClubRolesRepo>((ref) {
  return ClubRolesRepo(ref.watch(rolesCollectionRefProvider));
});

final roleByIdProvider =
    FutureProvider.family<ClubRole?, String>((ref, roleId) {
  return ref.watch(clubRolesRepoProvider).getRoleById(roleId);
});

// get all roles by club id provider
final allRolesByClubIdProvider =
    FutureProvider.family<List<ClubRole>?, String>((ref, clubId) {
  return ref.watch(clubRolesRepoProvider).getAllClubRoles(clubId);
});
