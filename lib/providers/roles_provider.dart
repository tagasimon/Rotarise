import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/models/club_role.dart';
import 'package:rotaract/providers/firebase_providers.dart';
import 'package:rotaract/repos/roles_repo.dart';

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
