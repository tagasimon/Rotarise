import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/providers/notification_providers.dart';
import 'package:rotaract/notifications/notifications_screen.dart';

/// Widget that shows notifications icon with badge count
class NotificationIconWithBadge extends ConsumerWidget {
  final VoidCallback? onPressed;
  final Color? iconColor;
  final double? iconSize;

  const NotificationIconWithBadge({
    super.key,
    this.onPressed,
    this.iconColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCountAsync = ref.watch(unreadNotificationsCountProvider);

    return IconButton(
      onPressed: onPressed ?? () => _navigateToNotifications(context),
      icon: Stack(
        children: [
          Icon(
            Icons.notifications,
            color: iconColor,
            size: iconSize,
          ),
          if (unreadCountAsync.hasValue && unreadCountAsync.value! > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: const BoxConstraints(
                  minWidth: 12,
                  minHeight: 12,
                ),
                child: Text(
                  unreadCountAsync.value! > 99
                      ? '99+'
                      : '${unreadCountAsync.value}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _navigateToNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationsScreen(),
      ),
    );
  }
}

/// Helper class for notification navigation
class NotificationNavigator {
  /// Navigate to notifications screen
  static void toNotificationsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationsScreen(),
      ),
    );
  }

  /// Navigate to notifications screen and clear navigation stack
  static void toNotificationsScreenAndClear(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationsScreen(),
      ),
      (route) => false,
    );
  }
}

/// Example usage widget for AppBar
class AppBarWithNotifications extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget>? additionalActions;

  const AppBarWithNotifications({
    super.key,
    required this.title,
    this.additionalActions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        ...?additionalActions,
        const NotificationIconWithBadge(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
