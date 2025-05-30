import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/providers/firebase_providers.dart';
import 'package:rotaract/discover/ui/events_screen/repos/club_events_repo.dart';

final clubEventsRepoProvider = Provider<ClubEventsRepo>((ref) {
  return ClubEventsRepo(ref.watch(eventsCollectionRefProvider));
});

// getAllEvents provider
final allEventsProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.watch(clubEventsRepoProvider);
  return repo.getAllEvents();
});

// getEventById
final clubEventByIdProvider =
    FutureProvider.family.autoDispose((ref, String eventId) async {
  final repo = ref.watch(clubEventsRepoProvider);
  return repo.getEventById(eventId);
});

// getEventsByClubId
final clubEventsByClubIdProvider =
    FutureProvider.family.autoDispose((ref, String clubId) async {
  final repo = ref.watch(clubEventsRepoProvider);
  return repo.getEventsByClubId(clubId);
});
