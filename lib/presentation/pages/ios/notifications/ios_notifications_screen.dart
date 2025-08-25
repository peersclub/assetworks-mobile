import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/ios18_theme.dart';
import '../../../controllers/notifications_controller.dart';
import '../../../widgets/ios/ios_loader.dart';

class IOSNotificationsScreen extends StatefulWidget {
  const IOSNotificationsScreen({super.key});
  
  @override
  State<IOSNotificationsScreen> createState() => _IOSNotificationsScreenState();
}

class _IOSNotificationsScreenState extends State<IOSNotificationsScreen> {
  final NotificationsController _controller = Get.put(NotificationsController());
  
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: iOS18Theme.background,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Notifications'),
            backgroundColor: iOS18Theme.background.withOpacity(0.5),
            border: null,
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Text(
                'Mark All Read',
                style: TextStyle(
                  color: iOS18Theme.accentBlue,
                  fontSize: 15,
                ),
              ),
              onPressed: () {
                _controller.markAllAsRead();
              },
            ),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () => _controller.loadNotifications(refresh: true),
          ),
          Obx(() {
            if (_controller.isLoading.value && _controller.notifications.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: IOSLoader(
                    message: 'Loading notifications...',
                  ),
                ),
              );
            }
            
            if (_controller.notifications.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.bell,
                        size: 64,
                        color: iOS18Theme.tertiaryLabel,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No notifications',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: iOS18Theme.primaryLabel,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You\'re all caught up!',
                        style: TextStyle(
                          fontSize: 16,
                          color: iOS18Theme.secondaryLabel,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final notification = _controller.notifications[index];
                  return _buildNotificationItem(notification);
                },
                childCount: _controller.notifications.length,
              ),
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildNotificationItem(NotificationModel notification) {
    return Dismissible(
      key: Key(notification.id ?? ''),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: iOS18Theme.accentRed,
        child: const Icon(
          CupertinoIcons.delete,
          color: CupertinoColors.white,
        ),
      ),
      onDismissed: (direction) {
        _controller.deleteNotification(notification.id!);
      },
      child: GestureDetector(
        onTap: () {
          iOS18Theme.selectionClick();
          _controller.markAsRead(notification.id!);
          _handleNotificationTap(notification);
        },
        child: Container(
          decoration: BoxDecoration(
            color: notification.isRead ? iOS18Theme.background : iOS18Theme.secondaryFill.withOpacity(0.3),
            border: Border(
              bottom: BorderSide(
                color: iOS18Theme.separator,
                width: 0.5,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getNotificationColor(notification.type).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getNotificationIcon(notification.type),
                    size: 20,
                    color: _getNotificationColor(notification.type),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: notification.isRead ? FontWeight.w400 : FontWeight.w600,
                                color: iOS18Theme.primaryLabel,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: iOS18Theme.accentBlue,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 14,
                          color: iOS18Theme.secondaryLabel,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _formatTime(notification.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: iOS18Theme.tertiaryLabel,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  CupertinoIcons.chevron_right,
                  size: 16,
                  color: iOS18Theme.tertiaryLabel,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'follow':
        return CupertinoIcons.person_add;
      case 'like':
        return CupertinoIcons.heart_fill;
      case 'comment':
        return CupertinoIcons.chat_bubble_fill;
      case 'share':
        return CupertinoIcons.share;
      case 'widget':
        return LucideIcons.fileText;
      case 'system':
        return CupertinoIcons.bell_fill;
      default:
        return CupertinoIcons.bell;
    }
  }
  
  Color _getNotificationColor(String type) {
    switch (type) {
      case 'follow':
        return iOS18Theme.accentBlue;
      case 'like':
        return iOS18Theme.accentRed;
      case 'comment':
        return iOS18Theme.accentGreen;
      case 'share':
        return iOS18Theme.accentOrange;
      case 'widget':
        return iOS18Theme.accentPurple;
      case 'system':
        return iOS18Theme.accentIndigo;
      default:
        return iOS18Theme.accentBlue;
    }
  }
  
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 7) {
      return '${time.day}/${time.month}/${time.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
  
  void _handleNotificationTap(NotificationModel notification) {
    switch (notification.type) {
      case 'follow':
        // Navigate to user profile
        if (notification.relatedUserId != null) {
          Get.toNamed('/profile', arguments: {'userId': notification.relatedUserId});
        }
        break;
      case 'like':
      case 'comment':
      case 'share':
      case 'widget':
        // Navigate to widget detail
        if (notification.relatedWidgetId != null) {
          Get.toNamed('/widget', arguments: {'widgetId': notification.relatedWidgetId});
        }
        break;
      case 'system':
        // Handle system notifications
        break;
    }
  }
}

class NotificationModel {
  final String? id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final String? relatedUserId;
  final String? relatedWidgetId;
  
  NotificationModel({
    this.id,
    required this.title,
    required this.message,
    required this.type,
    this.isRead = false,
    required this.createdAt,
    this.relatedUserId,
    this.relatedWidgetId,
  });
  
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? json['_id'],
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'system',
      isRead: json['isRead'] ?? json['is_read'] ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      relatedUserId: json['relatedUserId'] ?? json['related_user_id'],
      relatedWidgetId: json['relatedWidgetId'] ?? json['related_widget_id'],
    );
  }
  
  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    DateTime? createdAt,
    String? relatedUserId,
    String? relatedWidgetId,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      relatedUserId: relatedUserId ?? this.relatedUserId,
      relatedWidgetId: relatedWidgetId ?? this.relatedWidgetId,
    );
  }
}