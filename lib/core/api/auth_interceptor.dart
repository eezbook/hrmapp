import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage _secureStorage;
  final String _deviceId;

  AuthInterceptor(this._secureStorage, this._deviceId);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.read(SecureKeys.authToken);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    final companyId = await _secureStorage.read(SecureKeys.selectedCompanyId);
    if (companyId != null) {
      options.headers['X-HRM-Company-ID'] = companyId;
    }
    options.headers['X-Device-ID'] = _deviceId;
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    handler.next(options);
  }
}
