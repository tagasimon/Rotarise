import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:rotaract/discover/ui/events_screen/providers/club_events_providers.dart';
import 'package:rotaract/discover/ui/events_screen/widgets/event_item_widget.dart';

enum ViewMode { list, calendar }

class ClubEventsWidget extends ConsumerStatefulWidget {
  const ClubEventsWidget({super.key});

  @override
  ConsumerState<ClubEventsWidget> createState() => _ClubEventsWidgetState();
}

class _ClubEventsWidgetState extends ConsumerState<ClubEventsWidget> {
  ViewMode _viewMode = ViewMode.list;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final eventsProvider = ref.watch(eventsByClubIdProvider);

    return eventsProvider.when(
      data: (events) {
        if (events.isEmpty) {
          return const Center(child: Text("No Events"));
        }

        return CustomScrollView(
          slivers: [
            // View Toggle Header
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 16, bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey[300]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildToggleButton(
                            icon: Icons.list,
                            isSelected: _viewMode == ViewMode.list,
                            onTap: () =>
                                setState(() => _viewMode = ViewMode.list),
                          ),
                          const SizedBox(width: 4),
                          _buildToggleButton(
                            icon: Icons.calendar_month,
                            isSelected: _viewMode == ViewMode.calendar,
                            onTap: () =>
                                setState(() => _viewMode = ViewMode.calendar),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _viewMode == ViewMode.list
                ? _buildListViewSliver(events)
                : _buildCalendarViewSliver(events),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildToggleButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey[700],
          size: 20,
        ),
      ),
    );
  }

  Widget _buildListViewSliver(List<dynamic> events) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: EventItemWidget(event: events[index]),
        ),
        childCount: events.length,
      ),
    );
  }

  Widget _buildCalendarViewSliver(List<dynamic> events) {
    // Group events by date for calendar display
    Map<DateTime, List<dynamic>> eventsByDate = {};
    for (var event in events) {
      // Use startDate from ClubEventModel
      DateTime eventDate = event.startDate as DateTime;
      DateTime dateKey =
          DateTime(eventDate.year, eventDate.month, eventDate.day);

      if (eventsByDate[dateKey] == null) {
        eventsByDate[dateKey] = [];
      }
      eventsByDate[dateKey]!.add(event);
    }

    // Get events for selected day
    List<dynamic> selectedDayEvents = eventsByDate[DateTime(
            _selectedDay.year, _selectedDay.month, _selectedDay.day)] ??
        [];

    return SliverToBoxAdapter(
      child: Column(
        children: [
          // Calendar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TableCalendar<dynamic>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.month,
              eventLoader: (day) {
                DateTime dateKey = DateTime(day.year, day.month, day.day);
                return eventsByDate[dateKey] ?? [];
              },
              startingDayOfWeek: StartingDayOfWeek.monday,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                markerDecoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Selected day events
          if (selectedDayEvents.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Events on ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Events list for selected day
          if (selectedDayEvents.isEmpty)
            SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  'No events on ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            )
          else
            ...selectedDayEvents.map((event) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: EventItemWidget(event: event),
                )),

          const SizedBox(height: 20), // Bottom padding
        ],
      ),
    );
  }
}
