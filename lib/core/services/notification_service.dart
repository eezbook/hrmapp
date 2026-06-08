import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../storage/hive_storage.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const _channelId   = 'hrm_channel';
  static const _channelName = 'HRM Notifications';

  Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _localNotifications.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            importance: Importance.high,
          ),
        );
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _localNotifications.show(
      title.hashCode,
      title,
      body,
      NotificationDetails(
        android: const AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: payload,
    );

    final current =
        HiveStorage.notificationsBox.get(HiveKeys.unreadCount, defaultValue: 0)
            as int;
    await HiveStorage.notificationsBox.put(HiveKeys.unreadCount, current + 1);
  }

  void _onNotificationTap(NotificationResponse response) {
    if (response.payload != null) {
      _pendingRoute = response.payload;
    }
  }

  String? _pendingRoute;

  String? consumePendingRoute() {
    final route   = _pendingRoute;
    _pendingRoute = null;
    return route;
  }

  int get unreadCount =>
      HiveStorage.notificationsBox.get(HiveKeys.unreadCount, defaultValue: 0)
          as int;

  Future<void> clearUnreadCount() async {
    await HiveStorage.notificationsBox.put(HiveKeys.unreadCount, 0);
  }
}
