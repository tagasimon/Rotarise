import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/admin_tools/models/club_role.dart';
import 'package:rotaract/admin_tools/providers/club_roles_repo_providers.dart';
import 'package:rotaract/admin_tools/repos/roles_repo.dart';

// role controller provider
final roleControllerProvider =
    StateNotifierProvider<RolesControllerNotifier, AsyncValue>(
  (ref) => RolesControllerNotifier(ref.watch(clubRolesRepoProvider)),
);

class RolesControllerNotifier extends StateNotifier<AsyncValue> {
  final RolesRepo _repo;
  RolesControllerNotifier(this._repo) : super(const AsyncData([]));

  // add a new role
  Future<bool> addRole(ClubRole role) async {
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

  // update a role
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
