import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/admin_tools/ui/club_events/widgets/events_details_bottom_sheet.dart';
import 'package:rotaract/admin_tools/ui/club_events/widgets/events_empty_state.dart';
import 'package:rotaract/admin_tools/ui/club_events/widgets/events_error_state.dart';
import 'package:rotaract/admin_tools/ui/club_events/widgets/events_sort_control.dart';
import 'package:rotaract/discover/ui/events_tab_screen/models/club_event_model.dart';
import 'package:rotaract/discover/ui/events_tab_screen/providers/club_events_providers.dart';
import 'package:rotaract/admin_tools/ui/club_events/widgets/events_app_bar.dart';
import 'package:rotaract/admin_tools/ui/club_events/widgets/events_list_view.dart';

class EventsByClubScreen extends ConsumerStatefulWidget {
  final String? clubName;

  const EventsByClubScreen({super.key, this.clubName});

  @override
  ConsumerState<EventsByClubScreen> createState() => _EventsByClubScreenState();
}

class _EventsByClubScreenState extends ConsumerState<EventsByClubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _sortBy = 'date'; // 'date', 'title', 'location'
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ClubEventModel> _filterAndSortEvents(List<ClubEventModel> events) {
    // Filter by search query
    List<ClubEventModel> filteredEvents = events.where((event) {
      return event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.location.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    // Sort events
    filteredEvents.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'date':
          comparison =
              (a.startDate as DateTime).compareTo(b.startDate as DateTime);
          break;
        case 'title':
          comparison = a.title.compareTo(b.title);
          break;
        case 'location':
          comparison = a.location.compareTo(b.location);
          break;
      }
      return _isAscending ? comparison : -comparison;
    });

    return filteredEvents;
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _onSortChanged(String sortBy, bool isAscending) {
    setState(() {
      _sortBy = sortBy;
      _isAscending = isAscending;
    });
  }

  void _handleEventAction(String action, ClubEventModel event) {
    switch (action) {
      case 'view':
        _showEventDetails(event);
        break;
      case 'edit':
        // Navigate to edit event screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Edit event: ${event.title}')),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(event);
        break;
    }
  }

  void _showEventDetails(ClubEventModel event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EventDetailsBottomSheet(
        event: event,
        onEventAction: (p0, p1) => null,
        // TODO Handle this
        // onEdit: () => _handleEventAction('edit', event),
      ),
    );
  }

  void _showDeleteConfirmation(ClubEventModel event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text(
            'Are you sure you want to delete "${event.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement delete logic here
              // TODO Implement Delete Event
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Event "${event.title}" deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsyncValue = ref.watch(adminEventsByClubIdProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: EventsAppBar(
        clubName: widget.clubName,
        onSearchChanged: _onSearchChanged,
      ),
      body: eventsAsyncValue.when(
        data: (events) {
          final filteredEvents = _filterAndSortEvents(events);

          if (events.isEmpty) {
            return const EventsEmptyState();
          }

          return Column(
            children: [
              // Sort Controls
              EventsSortControls(
                eventsCount: filteredEvents.length,
                sortBy: _sortBy,
                isAscending: _isAscending,
                onSortChanged: _onSortChanged,
              ),

              // Content
              Expanded(
                child: EventsListView(
                  events: filteredEvents,
                  onEventTap: _showEventDetails,
                  onEventAction: _handleEventAction,
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => EventsErrorState(
          error: error.toString(),
          onRetry: () => ref.invalidate(adminEventsByClubIdProvider),
        ),
      ),
    );
  }
}
