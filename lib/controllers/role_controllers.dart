import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/models/club_role.dart';
import 'package:rotaract/providers/roles_provider.dart';
import 'package:rotaract/repos/roles_repo.dart';

// role controller provider
final roleControllerProvider =
    StateNotifierProvider<RoleControllerNotifier, AsyncValue<List<ClubRole>>>(
  (ref) => RoleControllerNotifier(ref.watch(rolesRepoProvider)),
);

class RoleControllerNotifier extends StateNotifier<AsyncValue<List<ClubRole>>> {
  final RolesRepo _repo;
  RoleControllerNotifier(this._repo) : super(const AsyncData([]));

  // add a new role
  Future<void> addRole(ClubRole role) async {
    state = const AsyncLoading();
    try {
      await _repo.createRole(role);
      state = const AsyncData([]);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  // update a role
  Future<void> updateRole(ClubRole role) async {
    state = const AsyncLoading();
    try {
      await _repo.updateRole(role);
      state = const AsyncData([]);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  // delete a role
  Future<void> deleteRole(String roleId) async {
    state = const AsyncLoading();
    try {
      await _repo.deleteRole(roleId);
      state = const AsyncData([]);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
}
