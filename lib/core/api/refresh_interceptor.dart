import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';

class RefreshInterceptor extends Interceptor {
  final Dio _dio;
  final SecureStorage _secureStorage;
  final String baseUrl;

  bool _isRefreshing = false;

  RefreshInterceptor(this._dio, this._secureStorage, this.baseUrl);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    if (_isRefreshing) {
      await _clearAndRedirect(handler, err);
      return;
    }

    _isRefreshing = true;

    try {
      final refreshToken =
          await _secureStorage.read(SecureKeys.refreshToken);
      if (refreshToken == null) {
        await _clearAndRedirect(handler, err);
        return;
      }

      final response = await _dio.post(
        '$baseUrl/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(headers: {'Authorization': ''}),
      );

      final newToken = response.data['data']['token'] as String;
      final newRefresh =
          response.data['data']['refresh_token'] as String? ?? refreshToken;
      await _secureStorage.write(SecureKeys.authToken, newToken);
      await _secureStorage.write(SecureKeys.refreshToken, newRefresh);

      final original = err.requestOptions;
      original.headers['Authorization'] = 'Bearer $newToken';
      final retryResponse = await _dio.fetch(original);
      handler.resolve(retryResponse);
    } catch (_) {
      await _clearAndRedirect(handler, err);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _clearAndRedirect(
    ErrorInterceptorHandler handler,
    DioException err,
  ) async {
    await _secureStorage.deleteAll();
    handler.next(err);
  }
}
