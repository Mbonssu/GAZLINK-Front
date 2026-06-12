import 'package:flutter/material.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';
import '../../routes.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_Notification> _notifications = [
    _Notification(
      id: '1',
      type: _NotificationType.order,
      title: 'Commande livrée',
      message: 'Votre commande CMD-002 a été livrée avec succès',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    _Notification(
      id: '2',
      type: _NotificationType.delivery,
      title: 'Livreur en route',
      message: 'Yannick est en route vers votre adresse. ETA: 15 min',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      isRead: false,
    ),
    _Notification(
      id: '3',
      type: _NotificationType.promo,
      title: 'Promotion spéciale',
      message: '10% de réduction sur votre prochaine commande',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    _Notification(
      id: '4',
      type: _NotificationType.order,
      title: 'Commande confirmée',
      message: 'Votre commande CMD-001 a été confirmée',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
    _Notification(
      id: '5',
      type: _NotificationType.system,
      title: 'Mise à jour disponible',
      message: 'Une nouvelle version de l\'application est disponible',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
  ];

  void _markAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (int i = 0; i < _notifications.length; i++) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    });
  }

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((n) => n.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('Notifications'),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text('Tout lire'),
            ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.notificationSettings),
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _buildNotificationCard(context, notification);
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 80,
            color: GlassConstants.mutedColor(Theme.of(context).brightness),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune notification',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: GlassConstants.mutedColor(Theme.of(context).brightness),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vous n\'avez pas de notifications pour le moment',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: GlassConstants.mutedColor(Theme.of(context).brightness),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, _Notification notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(GlassConstants.radiusM),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.red),
      ),
      onDismissed: (_) => _deleteNotification(notification.id),
      child: GlassCard(
        margin: const EdgeInsets.only(bottom: 12),
        onTap: () => _markAsRead(notification.id),
        color: notification.isRead
            ? null
            : GlassConstants.accent.withValues(alpha: 0.05),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getNotificationColor(notification.type).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getNotificationIcon(notification.type),
                color: _getNotificationColor(notification.type),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w700,
                              ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: GlassConstants.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: GlassConstants.mutedColor(Theme.of(context).brightness),
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatTimestamp(notification.timestamp),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: GlassConstants.mutedColor(Theme.of(context).brightness),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(_NotificationType type) {
    switch (type) {
      case _NotificationType.order:
        return Icons.shopping_bag_outlined;
      case _NotificationType.delivery:
        return Icons.local_shipping_outlined;
      case _NotificationType.promo:
        return Icons.local_offer_outlined;
      case _NotificationType.system:
        return Icons.info_outline;
    }
  }

  Color _getNotificationColor(_NotificationType type) {
    switch (type) {
      case _NotificationType.order:
        return GlassConstants.accent;
      case _NotificationType.delivery:
        return Colors.orange;
      case _NotificationType.promo:
        return Colors.green;
      case _NotificationType.system:
        return Colors.blue;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays}j';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

enum _NotificationType {
  order,
  delivery,
  promo,
  system,
}

class _Notification {
  final String id;
  final _NotificationType type;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  _Notification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isRead,
  });

  _Notification copyWith({
    String? id,
    _NotificationType? type,
    String? title,
    String? message,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return _Notification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}
