import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/discover/models/visit_model.dart';
import 'package:rotaract/discover/repos/visits_repo.dart';

final visitsControllerProvider =
    StateNotifierProvider<VisitsController, AsyncValue>((ref) {
  return VisitsController(ref.watch(visitsRepoProvider));
});

class VisitsController extends StateNotifier<AsyncValue> {
  final VisitsRepo _repo;
  VisitsController(this._repo) : super(const AsyncLoading());
  // add visit
  Future<bool> addVisit(VisitModel visit) async {
    try {
      await _repo.addVisit(visit);
      state = const AsyncData(null);
      return true;
    } catch (e, s) {
      state = AsyncError(e, s);
      return false;
    }
  }
  // delete visit

  Future<bool> deleteVisit(String visitId) async {
    try {
      await _repo.deleteVisit(visitId);
      state = const AsyncData(null);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }
}
