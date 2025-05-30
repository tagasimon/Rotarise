import 'package:rotaract/discover/ui/events_screen/models/club_event_model.dart';

abstract class ClubEventsInterface {
  // add a new event
  Future<void> addEvent({required ClubEventModel event});
  // get all events
  Future<List<ClubEventModel>> getAllEvents();
  // get events by club id
  Future<List<ClubEventModel>> getEventsByClubId(String clubId);
  // get event by id
  Future<ClubEventModel?> getEventById(String eventId);
  // update an event
  Future<void> updateEvent({required ClubEventModel event});
  // delete an event
  Future<void> deleteEvent(String eventId);
}
