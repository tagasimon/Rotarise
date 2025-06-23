import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DateHelpers {
  static String formatPostTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      // Format as date for older posts
      return '${timestamp.day}/${timestamp.month}/${timestamp.year.toString().substring(2)}';
    }
  }

  static String formatEventDate(Object startDate, Object endDate) {
    // Convert Object to DateTime - they should already be DateTime from fromMap
    final DateTime start = startDate as DateTime;
    final DateTime end = endDate as DateTime;

    final startFormatted = DateFormat('dd MMM').format(start);
    final endFormatted = DateFormat('dd MMM yyyy').format(end);

    // Check if it's the same day
    if (start.year == end.year &&
        start.month == end.month &&
        start.day == end.day) {
      return DateFormat('dd MMM yyyy').format(start);
    }

    return '$startFormatted - $endFormatted';
  }

  static Future<void> addToCalendar({
    required String title,
    required DateTime start,
    required DateTime end,
    String? description,
    String? location,
  }) async {
    try {
      // Format dates to UTC ISO 8601 format (required for calendar links)
      final startFormatted = _formatDateForCalendar(start.toUtc());
      final endFormatted = _formatDateForCalendar(end.toUtc());

      // Build the calendar URL
      final calendarUrl = Uri(
        scheme: 'https',
        host: 'calendar.google.com',
        path: '/calendar/render',
        queryParameters: {
          'action': 'TEMPLATE',
          'text': title,
          'dates': '$startFormatted/$endFormatted',
          if (description != null && description.isNotEmpty)
            'details': description,
          if (location != null && location.isNotEmpty) 'location': location,
        },
      );

      // Try to launch the URL
      if (await canLaunchUrl(calendarUrl)) {
        await launchUrl(
          calendarUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        debugPrint('Could not launch calendar URL: $calendarUrl');
        throw Exception('Could not open calendar app');
      }
    } catch (e) {
      debugPrint('Error opening calendar: $e');
      rethrow;
    }
  }

  /// Formats DateTime to the required format for calendar URLs
  /// Format: YYYYMMDDTHHMMSSZ
  static String _formatDateForCalendar(DateTime dateTime) {
    return dateTime
        .toIso8601String()
        .replaceAll(RegExp(r'[-:.]'), '')
        .split('T')
        .join('T')
        .replaceAll('000Z', 'Z');
  }

  /// Alternative method that tries multiple calendar apps/services
  static Future<void> addToCalendarWithFallback({
    required String title,
    required DateTime start,
    required DateTime end,
    String? description,
    String? location,
  }) async {
    try {
      // Try Google Calendar first
      await addToCalendar(
        title: title,
        start: start,
        end: end,
        description: description,
        location: location,
      );
    } catch (e) {
      debugPrint('Google Calendar failed: $e');
    }
  }
}
