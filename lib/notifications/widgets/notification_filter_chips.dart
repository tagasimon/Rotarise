import 'package:flutter/material.dart';
import 'package:rotaract/_core/models/notification_model.dart';

class NotificationFilterChips extends StatelessWidget {
  final NotificationType? selectedType;
  final Function(NotificationType?) onTypeSelected;

  const NotificationFilterChips({
    super.key,
    this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip(
            context,
            'All',
            null,
            selectedType == null,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context,
            'Club',
            NotificationType.clubInvitation,
            selectedType == NotificationType.clubInvitation,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context,
            'Events',
            NotificationType.eventInvitation,
            selectedType == NotificationType.eventInvitation,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context,
            'Announcements',
            NotificationType.announcement,
            selectedType == NotificationType.announcement,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context,
            'Achievements',
            NotificationType.achievement,
            selectedType == NotificationType.achievement,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    NotificationType? type,
    bool isSelected,
  ) {
    final theme = Theme.of(context);

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        onTypeSelected(selected ? type : null);
      },
      selectedColor: theme.primaryColor.withOpacity(0.2),
      checkmarkColor: theme.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? theme.primaryColor : Colors.grey[600],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      backgroundColor: Colors.grey[100],
      side: BorderSide(
        color: isSelected ? theme.primaryColor : Colors.grey[300]!,
        width: 1,
      ),
    );
  }
}
