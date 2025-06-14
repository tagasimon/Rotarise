import 'package:flutter/material.dart';

class EventsSortControls extends StatelessWidget {
  final int eventsCount;
  final String sortBy;
  final bool isAscending;
  final Function(String, bool) onSortChanged;

  const EventsSortControls({
    super.key,
    required this.eventsCount,
    required this.sortBy,
    required this.isAscending,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            '$eventsCount events',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          PopupMenuButton<String>(
            icon: Icon(Icons.sort, color: Colors.grey[600]),
            onSelected: (value) {
              if (sortBy == value) {
                onSortChanged(value, !isAscending);
              } else {
                onSortChanged(value, true);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'date',
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 20),
                    const SizedBox(width: 8),
                    const Text('Sort by Date'),
                    if (sortBy == 'date') ...[
                      const Spacer(),
                      Icon(
                        isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 16,
                      ),
                    ],
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'title',
                child: Row(
                  children: [
                    const Icon(Icons.title, size: 20),
                    const SizedBox(width: 8),
                    const Text('Sort by Title'),
                    if (sortBy == 'title') ...[
                      const Spacer(),
                      Icon(
                        isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 16,
                      ),
                    ],
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'location',
                child: Row(
                  children: [
                    const Icon(Icons.location_on, size: 20),
                    const SizedBox(width: 8),
                    const Text('Sort by Location'),
                    if (sortBy == 'location') ...[
                      const Spacer(),
                      Icon(
                        isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 16,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
