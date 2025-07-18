// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:rotaract/discover/domain/visits_interface.dart';
import 'package:rotaract/discover/models/visit_model.dart';

class VisitsRepo implements VisitsInterface {
  final CollectionReference _ref;
  VisitsRepo(this._ref);

  @override
  Future<void> addVisit(VisitModel visit) async {
    await _ref.add(visit.toMap());
  }

  @override
  Future<void> deleteVisit(String visitId) async {
    await _ref.doc(visitId).delete();
  }

  @override
  Future<List<VisitModel>> getVisitsByClub(String clubId) async {
    final snapshot = await _ref.where('clubId', isEqualTo: clubId).get();
    return snapshot.docs.map((doc) => VisitModel.fromFirestore(doc)).toList();
  }

  @override
  Future<List<VisitModel>> getVisitsByUser(String userId) async {
    final snapshot = await _ref.where('userId', isEqualTo: userId).get();
    return snapshot.docs.map((doc) => VisitModel.fromFirestore(doc)).toList();
  }

  @override
  Future<int> getVisitsCountByClub(String clubId) async {
    return await _ref
        .where('clubId', isEqualTo: clubId)
        .count()
        .get()
        .then((value) => value.count ?? 0);
  }

  @override
  Future<int> getVisitsCountByUser(String userId) async {
    return await _ref
        .where('userId', isEqualTo: userId)
        .count()
        .get()
        .then((value) => value.count ?? 0);
  }

  @override
  Future<bool> hasUserVisitedClub(String userId, String clubId) async {
    final snapshot = await _ref
        .where('userId', isEqualTo: userId)
        .where('clubId', isEqualTo: clubId)
        .get();
    return snapshot.docs.isNotEmpty;
  }
}
