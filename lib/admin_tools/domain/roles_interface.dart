import 'package:rotaract/admin_tools/models/club_role.dart';

abstract class RolesInterface {
  Future<void> createRole(ClubRole role);
  Future<void> updateRole(ClubRole role);
  Future<void> deleteRole(String roleId);
  Future<ClubRole?> getRoleById(String roleId);
  Future<List<ClubRole>?> getAllClubRoles(String clubId);
}
