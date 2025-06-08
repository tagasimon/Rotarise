import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rotaract/admin_tools/domain/role_interface.dart';
import 'package:rotaract/admin_tools/models/club_role.dart';

class ClubRolesRepo implements RoleInterface {
  final CollectionReference _ref;
  ClubRolesRepo(this._ref);
  @override
  Future<void> createRole(ClubRole role) async {
    await _ref.add(role.toMap());
  }

  @override
  Future<void> updateRole(ClubRole role) async {
    final ref = await _ref.where('id', isEqualTo: role.id).get();

    if (ref.docs.isNotEmpty) {
      await ref.docs.first.reference.update(role.toMap());
    }
  }

  @override
  Future<void> deleteRole(String roleId) async {
    final ref = await _ref.where('id', isEqualTo: roleId).get();

    if (ref.docs.isNotEmpty) {
      await ref.docs.first.reference.delete();
    }
  }

  @override
  Future<ClubRole?> getRoleById(String roleId) async {
    final ref = await _ref.where('id', isEqualTo: roleId).get();

    if (ref.docs.isNotEmpty) {
      return ClubRole.fromFirestore(ref.docs.first);
    }
    return null;
  }

  @override
  Future<List<ClubRole>?> getAllClubRoles(String clubId) async {
    final ref = await _ref.where('clubId', isEqualTo: clubId).get();

    if (ref.docs.isNotEmpty) {
      return ref.docs.map((e) => ClubRole.fromFirestore(e)).toList();
    }
    return null;
  }
}
