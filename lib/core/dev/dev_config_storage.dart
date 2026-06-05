import 'package:hive_flutter/hive_flutter.dart';

/// Dev-only storage for local development configuration.
///
/// Manages the [_boxName] Hive box independently from [HiveStorage] because
/// this box must be opened before [AppConfig.initialize()] is called — earlier
/// than the rest of the Hive boxes in [HiveStorage.openBoxes()].
class DevConfigStorage {
  DevConfigStorage._();

  static const _boxName = 'dev_config';
  static const _keyApiBaseUrl = 'api_base_url';

  static Future<void> openBox() async {
    await Hive.openBox(_boxName);
  }

  static Box get _box => Hive.box(_boxName);

  static String? getApiBaseUrl() => _box.get(_keyApiBaseUrl) as String?;

  static Future<void> saveApiBaseUrl(String url) async {
    await _box.put(_keyApiBaseUrl, url);
  }

  static Future<void> clearApiBaseUrl() async {
    await _box.delete(_keyApiBaseUrl);
  }
}
