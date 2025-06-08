import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/discover/ui/events_screen/models/club_event_model.dart';
import 'package:rotaract/discover/ui/events_screen/providers/club_events_providers.dart';
import 'package:rotaract/discover/ui/events_screen/repos/club_events_repo.dart';

// club events controller provider
final clubEventsControllerProvider =
    StateNotifierProvider<ClubEventsController, AsyncValue>(
  (ref) => ClubEventsController(ref.watch(clubEventsRepoProvider)),
);

class ClubEventsController extends StateNotifier<AsyncValue> {
  final ClubEventsRepo _repo;
  ClubEventsController(this._repo) : super(const AsyncValue.loading());

  Future<bool> addEvent({required ClubEventModel event}) async {
    try {
      await _repo.addEvent(event: event);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      return false;
    }
  }

  // update an event
  Future<bool> updateEvent({required ClubEventModel event}) async {
    try {
      await _repo.updateEvent(event: event);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      return true;
    }
  }

  // delete an event
  Future<void> deleteEvent(String eventId) async {
    try {
      await _repo.deleteEvent(eventId);
      state = const AsyncValue.data(null);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
