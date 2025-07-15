import 'package:flutter/material.dart';
import 'package:rotaract/_core/extensions/color_extension.dart';
import 'package:rotaract/discover/ui/events_tab_screen/models/club_event_model.dart';

class EventsListView extends StatelessWidget {
  final List<ClubEventModel> events;
  final Function(ClubEventModel) onEventTap;
  final Function(String, ClubEventModel) onEventAction;

  const EventsListView({
    super.key,
    required this.events,
    required this.onEventTap,
    required this.onEventAction,
  });

  String _formatDateTime(DateTime dateTime, BuildContext context) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${TimeOfDay.fromDateTime(dateTime).format(context)}';
  }

  String _formatDateOnly(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _getEventStatus(ClubEventModel event) {
    final now = DateTime.now();
    final startDate = event.startDate as DateTime;
    final endDate = event.endDate as DateTime;

    if (now.isBefore(startDate)) {
      return 'Upcoming';
    } else if (now.isAfter(endDate)) {
      return 'Completed';
    } else {
      return 'Ongoing';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Upcoming':
        return Colors.pink;
      case 'Ongoing':
        return Colors.green;
      case 'Completed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final status = _getEventStatus(event);
        final statusColor = _getStatusColor(status);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlphaa(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => onEventTap(event),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Image or Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.blue.withAlphaa(0.1),
                    ),
                    child: event.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              event.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.event,
                                      color: Colors.pink.shade400, size: 40),
                            ),
                          )
                        : Icon(Icons.event,
                            color: Colors.pink.shade400, size: 40),
                  ),
                  const SizedBox(width: 16),

                  // Event Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Status Row
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                event.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withAlphaa(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Event Type and Payment Badges
                        Row(
                          children: [
                            // Online/Offline Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: event.isOnline
                                    ? Colors.purple.shade100
                                    : Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    event.isOnline
                                        ? Icons.computer
                                        : Icons.location_on,
                                    size: 12,
                                    color: event.isOnline
                                        ? Colors.purple
                                        : Colors.blue,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    event.isOnline ? 'ONLINE' : 'OFFLINE',
                                    style: TextStyle(
                                      color: event.isOnline
                                          ? Colors.purple
                                          : Colors.blue,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Payment Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: event.isPaid
                                    ? Colors.orange.shade100
                                    : Colors.green.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    event.isPaid
                                        ? Icons.payment
                                        : Icons.celebration,
                                    size: 12,
                                    color: event.isPaid
                                        ? Colors.orange
                                        : Colors.green,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    event.isPaid
                                        ? (event.amount != null
                                            ? '\$${event.amount!.toStringAsFixed(0)}'
                                            : 'PAID')
                                        : 'FREE',
                                    style: TextStyle(
                                      color: event.isPaid
                                          ? Colors.orange
                                          : Colors.green,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Date
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 6),
                            Text(
                              _formatDateOnly(event.startDate as DateTime),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Location/Link
                        Row(
                          children: [
                            Icon(
                                event.isOnline ? Icons.link : Icons.location_on,
                                size: 16,
                                color: event.isOnline
                                    ? Colors.purple[600]
                                    : Colors.grey[600]),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                event.isOnline
                                    ? (event.eventLink != null
                                        ? 'Event Link Available'
                                        : 'Online Event')
                                    : event.location,
                                style: TextStyle(
                                  color: event.isOnline
                                      ? Colors.purple[600]
                                      : Colors.grey[600],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Duration
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Duration: ${_formatDateTime(event.startDate as DateTime, context)} - ${_formatDateTime(event.endDate as DateTime, context)}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action Menu
                  PopupMenuButton(
                    icon: Icon(Icons.more_vert, color: Colors.grey[400]),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            Icon(Icons.visibility, size: 20),
                            SizedBox(width: 8),
                            Text('View Details'),
                          ],
                        ),
                      ),
                      if (event.isOnline && event.eventLink != null)
                        const PopupMenuItem(
                          value: 'join',
                          child: Row(
                            children: [
                              Icon(Icons.launch,
                                  size: 20, color: Colors.purple),
                              SizedBox(width: 8),
                              Text('Join Event',
                                  style: TextStyle(color: Colors.purple)),
                            ],
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Edit Event'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'duplicate',
                        child: Row(
                          children: [
                            Icon(Icons.copy, size: 20, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Duplicate Event',
                                style: TextStyle(color: Colors.blue)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: [
                            Icon(Icons.share, size: 20, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Share Event',
                                style: TextStyle(color: Colors.green)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete Event',
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) =>
                        onEventAction(value.toString(), event),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
