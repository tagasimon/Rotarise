import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/admin_tools/models/club_model.dart';
import 'package:rotaract/admin_tools/providers/club_repo_providers.dart';
import 'package:rotaract/admin_tools/repos/clubs_repo.dart';

// club controller provider
final clubControllerProvider =
    StateNotifierProvider<ClubControllerNotifier, AsyncValue>(
  (ref) => ClubControllerNotifier(ref.watch(clubRepoProvider)),
);

class ClubControllerNotifier extends StateNotifier<AsyncValue> {
  final ClubsRepo _repo;
  ClubControllerNotifier(this._repo) : super(const AsyncData(null));

  // add a new club
  Future<void> addClub(ClubModel club) async {
    state = const AsyncLoading();
    try {
      await _repo.createClub(club);
      state = const AsyncData(null);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  // update a club
  Future<void> updateClub(ClubModel club) async {
    state = const AsyncLoading();
    try {
      await _repo.updateClub(club);
      state = const AsyncData(null);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  // delete a club

  // Future<void> deleteClub(ClubModel club) async {
  //   state = const AsyncLoading();
  //   try {
  //     await _repo.deleteClub(club);
  //     state = const AsyncData(null);
  //   } catch (e, s) {
  //     state = AsyncError(e, s);
  //   }
  // }
}
