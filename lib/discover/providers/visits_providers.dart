// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/_core/providers/firebase_providers.dart';

import 'package:rotaract/discover/models/visit_model.dart';
import 'package:rotaract/discover/repos/visits_repo.dart';

final visitsRepoProvider = Provider<VisitsRepo>((ref) {
  return VisitsRepo(ref.watch(meetupsCollectionRefProvider));
});

// getVisitsByClub
final visitsByClubProvider =
    FutureProvider.autoDispose.family<List<VisitModel>, String>(
  (ref, clubId) {
    return ref.watch(visitsRepoProvider).getVisitsByClub(clubId);
  },
);

final cUserVisitsByUserProvider = FutureProvider.autoDispose<List<VisitModel>>(
  (ref) {
    final cUser = ref.watch(currentUserNotifierProvider);
    if (cUser == null) {
      return Future.error('User not authenticated');
    }
    return ref.watch(visitsRepoProvider).getVisitsByUser(cUser.id);
  },
);

final visitsByUserProvider =
    FutureProvider.autoDispose.family<List<VisitModel>, String>(
  (ref, userId) {
    return ref.watch(visitsRepoProvider).getVisitsByUser(userId);
  },
);

// getVisitsCountByClub

final visitsCountByClubProvider =
    FutureProvider.autoDispose.family<int, String>(
  (ref, clubId) {
    return ref.watch(visitsRepoProvider).getVisitsCountByClub(clubId);
  },
);

// getVisitsCountByUser
final visitsCountByUserProvider =
    FutureProvider.autoDispose.family<int, String>(
  (ref, userId) {
    return ref.watch(visitsRepoProvider).getVisitsCountByUser(userId);
  },
);
