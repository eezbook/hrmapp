import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureKeys {
  static const authToken = 'hrm_auth_token';
  static const refreshToken = 'hrm_refresh_token';
  static const employeeId = 'employee_id';
  static const employeeRole = 'employee_role';
  static const storedEmail = 'stored_email';
  static const storedPassword = 'stored_password';
  static const selectedCompanyId = 'selected_company_id';
}

class SecureStorage {
  final FlutterSecureStorage _storage;

  SecureStorage(this._storage);

  Future<String?> read(String key) => _storage.read(key: key);

  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  Future<void> delete(String key) => _storage.delete(key: key);

  Future<void> deleteAll() => _storage.deleteAll();

  Future<bool> containsKey(String key) => _storage.containsKey(key: key);
}
