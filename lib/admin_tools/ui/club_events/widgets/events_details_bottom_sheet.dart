import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/discover/ui/events_tab_screen/models/club_event_model.dart';

class EventDetailsBottomSheet extends ConsumerWidget {
  final ClubEventModel event;

  const EventDetailsBottomSheet({
    super.key,
    required this.event,
  });

  String _formatDateTime(DateTime dateTime, BuildContext context) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${TimeOfDay.fromDateTime(dateTime).format(context)}';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event Image
                      if (event.imageUrl != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            event.imageUrl!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              height: 200,
                              color: Colors.grey[200],
                              child: const Icon(Icons.event, size: 60),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Event Title
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Event Details
                      _buildDetailRow(
                          Icons.calendar_today,
                          'Start Date',
                          _formatDateTime(
                              event.startDate as DateTime, context)),
                      _buildDetailRow(Icons.calendar_today_outlined, 'End Date',
                          _formatDateTime(event.endDate as DateTime, context)),
                      _buildDetailRow(
                          event.isOnline ? Icons.link : Icons.location_on,
                          event.isOnline ? 'Event Link' : 'Location',
                          event.isOnline
                              ? (event.eventLink ?? 'No link provided')
                              : event.location),
                      _buildDetailRow(
                          Icons.info_outline, 'Status', _getEventStatus(event)),
                      _buildDetailRow(
                          event.isPaid ? Icons.payment : Icons.money_off,
                          'Cost',
                          event.isPaid
                              ? (event.amount != null
                                  ? '\$${event.amount!.toStringAsFixed(2)}'
                                  : 'Paid Event')
                              : 'Free'),
                      _buildDetailRow(Icons.computer, 'Event Type',
                          event.isOnline ? 'Online Event' : 'In-Person Event'),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
