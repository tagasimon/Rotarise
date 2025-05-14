import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rotaract/models/member_model.dart';

class MembersRepo {
  final CollectionReference _ref;
  MembersRepo(this._ref);

  // create a new member
  Future<void> createMember(MemberModel member) async {
    await _ref.add(member.toMap());
  }

  // update a member
  Future<void> updateMember(MemberModel member) async {
    final ref = await _ref.where('id', isEqualTo: member.id).get();

    if (ref.docs.isNotEmpty) {
      await ref.docs.first.reference.update(member.toMap());
    }
  }

  // delete a member
  Future<void> deleteMember(MemberModel member) async {
    final ref = await _ref.where('id', isEqualTo: member.id).get();

    if (ref.docs.isNotEmpty) {
      await ref.docs.first.reference.delete();
    }
  }

  // get a member by id
  Future<MemberModel?> getMemberById(String id) async {
    final ref = await _ref.where('id', isEqualTo: id).get();

    if (ref.docs.isNotEmpty) {
      return MemberModel.fromMap(ref.docs.first);
    }
    return null;
  }

  // get all members
  Future<List<MemberModel>> getAllMembers() async {
    return await _ref.get().then((snapshot) {
      return snapshot.docs.map((e) => MemberModel.fromMap(e)).toList();
    });
  }

  // get all members by club id
  Future<List<MemberModel>> getAllMembersByClubId(String clubId) async {
    final ref = await _ref.where('clubId', isEqualTo: clubId).get();
    return ref.docs.map((e) => MemberModel.fromMap(e)).toList();
  }
}
