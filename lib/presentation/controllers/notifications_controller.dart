import 'package:get/get.dart';
import '../pages/ios/notifications/ios_notifications_screen.dart';
import '../../services/api_service.dart';
import '../../core/utils/helpers.dart';
import '../../core/theme/ios18_theme.dart';

class NotificationsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt unreadCount = 0.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }
  
  Future<void> loadNotifications({bool refresh = false}) async {
    try {
      isLoading.value = true;
      
      // For now, create mock notifications
      // In production, this would call the API
      final mockNotifications = [
        NotificationModel(
          id: '1',
          title: 'New follower',
          message: 'John Doe started following you',
          type: 'follow',
          isRead: false,
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
          relatedUserId: 'user123',
        ),
        NotificationModel(
          id: '2',
          title: 'Report liked',
          message: 'Sarah Smith liked your Tesla analysis report',
          type: 'like',
          isRead: false,
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          relatedWidgetId: 'widget456',
        ),
        NotificationModel(
          id: '3',
          title: 'New comment',
          message: 'Mike Johnson commented on your Bitcoin prediction',
          type: 'comment',
          isRead: true,
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          relatedWidgetId: 'widget789',
        ),
        NotificationModel(
          id: '4',
          title: 'Report shared',
          message: 'Emma Wilson shared your market analysis',
          type: 'share',
          isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          relatedWidgetId: 'widget101',
        ),
        NotificationModel(
          id: '5',
          title: 'Weekly summary',
          message: 'Your reports received 1,234 views this week',
          type: 'system',
          isRead: false,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ];
      
      if (refresh) {
        notifications.value = mockNotifications;
      } else {
        notifications.value = mockNotifications;
      }
      
      _updateUnreadCount();
      
    } catch (e) {
      print('Error loading notifications: $e');
      showToast('Failed to load notifications', isError: true);
    } finally {
      isLoading.value = false;
    }
  }
  
  void markAsRead(String notificationId) {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1 && !notifications[index].isRead) {
      notifications[index] = notifications[index].copyWith(isRead: true);
      _updateUnreadCount();
      
      // In production, call API to mark as read
      _markAsReadOnServer(notificationId);
    }
  }
  
  void markAllAsRead() {
    iOS18Theme.lightImpact();
    
    for (int i = 0; i < notifications.length; i++) {
      if (!notifications[i].isRead) {
        notifications[i] = notifications[i].copyWith(isRead: true);
      }
    }
    
    _updateUnreadCount();
    showToast('All notifications marked as read');
    
    // In production, call API to mark all as read
    _markAllAsReadOnServer();
  }
  
  void deleteNotification(String notificationId) {
    iOS18Theme.lightImpact();
    
    notifications.removeWhere((n) => n.id == notificationId);
    _updateUnreadCount();
    showToast('Notification deleted');
    
    // In production, call API to delete notification
    _deleteNotificationOnServer(notificationId);
  }
  
  void _updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }
  
  Future<void> _markAsReadOnServer(String notificationId) async {
    // API call to mark notification as read
    try {
      // await _apiService.markNotificationAsRead(notificationId);
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }
  
  Future<void> _markAllAsReadOnServer() async {
    // API call to mark all notifications as read
    try {
      // await _apiService.markAllNotificationsAsRead();
    } catch (e) {
      print('Error marking all notifications as read: $e');
    }
  }
  
  Future<void> _deleteNotificationOnServer(String notificationId) async {
    // API call to delete notification
    try {
      // await _apiService.deleteNotification(notificationId);
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }
}