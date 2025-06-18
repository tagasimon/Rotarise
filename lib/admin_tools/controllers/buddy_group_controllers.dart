import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/admin_tools/models/club_role.dart';
import 'package:rotaract/admin_tools/providers/club_roles_repo_providers.dart';
import 'package:rotaract/admin_tools/repos/club_roles_repo.dart';

// role controller provider
final roleControllerProvider =
    StateNotifierProvider<BuddyGroupControllers, AsyncValue>(
  (ref) => BuddyGroupControllers(ref.watch(clubRolesRepoProvider)),
);

class BuddyGroupControllers extends StateNotifier<AsyncValue> {
  final ClubRolesRepo _repo;
  BuddyGroupControllers(this._repo) : super(const AsyncData([]));

  Future<bool> addBuddyGroup(ClubRole role) async {
    state = const AsyncLoading();
    try {
      await _repo.createRole(role);
      state = const AsyncData(null);
      return true;
    } catch (e, s) {
      state = AsyncError(e, s);
      return false;
    }
  }

  Future<bool> updateRole(ClubRole role) async {
    state = const AsyncLoading();
    try {
      await _repo.updateRole(role);
      state = const AsyncData(null);
      return true;
    } catch (e, s) {
      state = AsyncError(e, s);
      return false;
    }
  }
}
