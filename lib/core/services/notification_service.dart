import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../storage/hive_storage.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'hrm_channel';
  static const _channelName = 'HRM Notifications';

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  Future<void> initialize() async {
    await _setupLocalNotifications();
    await _setupFcm();
  }

  Future<void> _setupLocalNotifications() async {
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

  Future<void> _setupFcm() async {
    await FirebaseMessaging.instance.requestPermission();
    _fcmToken = await FirebaseMessaging.instance.getToken();

    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      _fcmToken = token;
    });

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: message.data['route'] as String?,
    );

    final current =
        HiveStorage.notificationsBox.get(HiveKeys.unreadCount, defaultValue: 0)
            as int;
    await HiveStorage.notificationsBox.put(HiveKeys.unreadCount, current + 1);
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    final route = message.data['route'] as String?;
    if (route != null) {
      _pendingRoute = route;
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    if (response.payload != null) {
      _pendingRoute = response.payload;
    }
  }

  String? _pendingRoute;

  String? consumePendingRoute() {
    final route = _pendingRoute;
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
