import 'package:hive_flutter/hive_flutter.dart';

abstract class HiveKeys {
  static const appBox = 'app_box';
  static const employeeBox = 'employee_box';
  static const permissionsBox = 'permissions_box';
  static const notifications = 'notifications_box';
  static const trainingBox = 'training_box';

  static const permissions = 'hrm_permissions';
  static const employee = 'employee_profile';
  static const biometricEnabled = 'biometric_enabled';
  static const themeMode = 'theme_mode';
  static const unreadCount = 'unread_notification_count';
  static const lastUpdated = 'last_updated_';
  static const videoPosition = 'video_position_';
}

class HiveStorage {
  static void registerAdapters() {
    // Adapters are registered via generated code — nothing manual needed.
  }

  static Future<void> openBoxes() async {
    await Future.wait([
      Hive.openBox(HiveKeys.appBox),
      Hive.openBox(HiveKeys.employeeBox),
      Hive.openBox(HiveKeys.permissionsBox),
      Hive.openBox(HiveKeys.notifications),
      Hive.openBox(HiveKeys.trainingBox),
    ]);
  }

  static Box get app => Hive.box(HiveKeys.appBox);
  static Box get employee => Hive.box(HiveKeys.employeeBox);
  static Box get permissions => Hive.box(HiveKeys.permissionsBox);
  static Box get notificationsBox => Hive.box(HiveKeys.notifications);
  static Box get training => Hive.box(HiveKeys.trainingBox);

  static Future<void> put(Box box, String key, dynamic value) async {
    await box.put(key, value);
  }

  static T? get<T>(Box box, String key) => box.get(key) as T?;

  static Future<void> delete(Box box, String key) async {
    await box.delete(key);
  }

  static void markUpdated(String feature) {
    app.put('${HiveKeys.lastUpdated}$feature', DateTime.now().toIso8601String());
  }

  static DateTime? lastUpdated(String feature) {
    final raw = app.get('${HiveKeys.lastUpdated}$feature') as String?;
    return raw != null ? DateTime.tryParse(raw) : null;
  }
}
