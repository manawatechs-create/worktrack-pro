import 'package:flutter/material.dart';

enum NotificationType { success, error, warning, info }

class NotificationService {
  static void show(
    BuildContext context, {
    required String message,
    NotificationType type = NotificationType.info,
    Duration duration = const Duration(seconds: 3),
    String? title,
  }) {
    final colors = {
      NotificationType.success: Colors.green,
      NotificationType.error: Colors.red,
      NotificationType.warning: Colors.orange,
      NotificationType.info: Colors.blue,
    };

    final icons = {
      NotificationType.success: Icons.check_circle,
      NotificationType.error: Icons.error,
      NotificationType.warning: Icons.warning,
      NotificationType.info: Icons.info,
    };

    final color = colors[type]!;
    final icon = icons[type]!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                  Text(message, style: const TextStyle(fontSize: 13, color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: duration,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  static void success(BuildContext context, String message, {String? title}) {
    show(context, message: message, type: NotificationType.success, title: title);
  }

  static void error(BuildContext context, String message, {String? title}) {
    show(context, message: message, type: NotificationType.error, duration: const Duration(seconds: 5), title: title);
  }

  static void warning(BuildContext context, String message, {String? title}) {
    show(context, message: message, type: NotificationType.warning, title: title);
  }

  static void info(BuildContext context, String message, {String? title}) {
    show(context, message: message, type: NotificationType.info, title: title);
  }
}
