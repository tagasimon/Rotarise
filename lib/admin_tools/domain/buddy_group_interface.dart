import 'package:rotaract/admin_tools/models/buddy_group_model.dart';

abstract class BuddyGroupInterface {
  Future<void> createBuddyGroup(BuddyGroupModel group);
  Future<void> updateBuddyGroup(BuddyGroupModel group);
  Future<void> deleteBuddyGroup(BuddyGroupModel group);
  Future<int> getTotalBuddyGroupsCountByClubId();
}
