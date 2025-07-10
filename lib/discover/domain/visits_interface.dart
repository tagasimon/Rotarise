import 'package:rotaract/discover/models/visit_model.dart';

abstract class VisitsInterface {
  // add visit
  Future<void> addVisit(VisitModel visit);
  // get visits by user
  Future<List<VisitModel>> getVisitsByUser(String userId);
  // get visits by club
  Future<List<VisitModel>> getVisitsByClub(String clubId);
  // delete visit
  Future<void> deleteVisit(String visitId);
  // check if user has visited a club
  Future<bool> hasUserVisitedClub(String userId, String clubId);
  // get visits count by club
  Future<int> getVisitsCountByClub(String clubId);
  // get visits count by user
  Future<int> getVisitsCountByUser(String userId);
}
