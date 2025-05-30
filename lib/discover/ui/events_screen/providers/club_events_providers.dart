import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/selected_club_notifier.dart';
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
final clubEventsByClubIdProvider = FutureProvider.autoDispose((ref) async {
  final cClub = ref.watch(selectedClubNotifierProvider);
  final repo = ref.watch(clubEventsRepoProvider);
  if (cClub == null) {
    return []; // or handle the case where no club is selected
  }
  return repo.getEventsByClubId(cClub.id);
});

// get total events count
final getTotalEventsCountProvider = FutureProvider((ref) async {
  return ref.read(clubEventsRepoProvider).getTotalEventsCount();
});

// get total events by club id
final getTotalEventsByClubIdProvider = FutureProvider.autoDispose((ref) async {
  final cClub = ref.watch(selectedClubNotifierProvider);
  final repo = ref.watch(clubEventsRepoProvider);
  if (cClub == null) {
    return 0; // or handle the case where no club is selected
  }
  return repo.getTotalEventsByClubId(cClub.id);
});
