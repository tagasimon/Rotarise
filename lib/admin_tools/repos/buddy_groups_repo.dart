// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rotaract/admin_tools/domain/buddy_groups_interface.dart';
import 'package:rotaract/admin_tools/models/buddy_group_model.dart';

class BuddyGroupsRepo implements BuddyGroupsInterface {
  final CollectionReference _ref;
  BuddyGroupsRepo(this._ref);

  @override
  Future<void> createBuddyGroup(BuddyGroupModel group) async {
    await _ref.add(group.toMap());
  }

  @override
  Future<void> deleteBuddyGroup(BuddyGroupModel group) {
    // TODO: implement deleteBuddyGroup
    throw UnimplementedError();
  }

  @override
  Future<void> updateBuddyGroup(BuddyGroupModel group) async {
    final ref = await _ref.where('clubId', isEqualTo: group.clubId).get();

    if (ref.docs.isNotEmpty) {
      await ref.docs.first.reference.update(group.toMap());
    }
  }

  @override
  Future<int> getTotalBuddyGroupsCountByClubId() {
    // TODO: implement getTotalBuddyGroupsCountByClubId
    throw UnimplementedError();
  }
}
