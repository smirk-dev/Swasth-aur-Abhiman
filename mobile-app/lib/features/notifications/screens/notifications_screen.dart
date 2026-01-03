import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String type;
  final String? imageUrl;
  final String? actionUrl;
  final bool isRead;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.imageUrl,
    this.actionUrl,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      imageUrl: json['imageUrl'],
      actionUrl: json['actionUrl'],
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Color getTypeColor() {
    switch (type) {
      case 'MESSAGE':
        return Colors.blue;
      case 'HEALTH_ALERT':
        return Colors.red;
      case 'PRESCRIPTION':
        return Colors.orange;
      case 'ASSIGNMENT':
        return Colors.purple;
      case 'SKILL_CERTIFICATION':
        return Colors.green;
      case 'APPOINTMENT':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData getTypeIcon() {
    switch (type) {
      case 'MESSAGE':
        return Icons.message;
      case 'HEALTH_ALERT':
        return Icons.warning;
      case 'PRESCRIPTION':
        return Icons.local_pharmacy;
      case 'ASSIGNMENT':
        return Icons.assignment;
      case 'SKILL_CERTIFICATION':
        return Icons.verified;
      case 'APPOINTMENT':
        return Icons.calendar_today;
      default:
        return Icons.notifications;
    }
  }
}

// Providers
final notificationsProvider = FutureProvider<({
  List<NotificationItem> notifications,
  int unreadCount,
  int total,
})>((ref) async {
  // TODO: Fetch from API /notifications
  return (
    notifications: [],
    unreadCount: 0,
    total: 0,
  );
});

final unreadNotificationCountProvider = FutureProvider<int>((ref) async {
  // TODO: Fetch from API /notifications/unread-count
  return 0;
});

// Notifications Screen
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  String? selectedFilter;

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_all),
            onPressed: () {
              // TODO: Mark all as read
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All marked as read')),
              );
            },
          ),
        ],
      ),
      body: notificationsAsync.when(
        data: (data) => Column(
          children: [
            // Filter Chips
            Padding(
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: selectedFilter == null,
                      onSelected: (selected) {
                        setState(() => selectedFilter = null);
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Unread'),
                      selected: selectedFilter == 'unread',
                      onSelected: (selected) {
                        setState(() =>
                            selectedFilter = selected ? 'unread' : null);
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Health'),
                      selected: selectedFilter == 'HEALTH_ALERT',
                      onSelected: (selected) {
                        setState(() => selectedFilter =
                            selected ? 'HEALTH_ALERT' : null);
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Messages'),
                      selected: selectedFilter == 'MESSAGE',
                      onSelected: (selected) {
                        setState(() =>
                            selectedFilter = selected ? 'MESSAGE' : null);
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Notifications List
            Expanded(
              child: data.notifications.isEmpty
                  ? Center(
                      child: Text(
                        'No notifications',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  : ListView.builder(
                      itemCount: data.notifications.length,
                      itemBuilder: (context, index) {
                        final notification = data.notifications[index];
                        return _buildNotificationCard(context, notification);
                      },
                    ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationItem notification,
  ) {
    return Dismissible(
      key: Key(notification.id),
      onDismissed: (_) {
        // TODO: Delete notification
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: notification.getTypeColor().withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              notification.getTypeIcon(),
              color: notification.getTypeColor(),
            ),
          ),
          title: Text(
            notification.title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: notification.isRead
                  ? FontWeight.normal
                  : FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                notification.message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                _formatTime(notification.createdAt),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
          trailing: !notification.isRead
              ? Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(50),
                  ),
                )
              : null,
          onTap: () {
            // TODO: Mark as read and navigate if actionUrl exists
            if (notification.actionUrl != null) {
              // Navigator.pushNamed(context, notification.actionUrl!);
            }
          },
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return dateTime.toIso8601String().split('T')[0];
    }
  }
}

// Notification Badge Widget
class NotificationBadge extends ConsumerWidget {
  const NotificationBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countAsync = ref.watch(unreadNotificationCountProvider);

    return countAsync.when(
      data: (count) => count > 0
          ? Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  count > 99 ? '99+' : '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

// In-App Toast Notification Widget
void showNotificationToast(
  BuildContext context,
  NotificationItem notification,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            notification.getTypeIcon(),
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(notification.message),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: notification.getTypeColor(),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: 'View',
        textColor: Colors.white,
        onPressed: () {
          if (notification.actionUrl != null) {
            // Navigator.pushNamed(context, notification.actionUrl!);
          }
        },
      ),
    ),
  );
}
