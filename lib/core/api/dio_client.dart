import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../storage/secure_storage.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';
import 'refresh_interceptor.dart';

class DioClient {
  late final Dio dio;

  DioClient(SecureStorage secureStorage, String deviceId) {
    dio = Dio(
      BaseOptions(
        baseUrl: '${AppConfig.apiBaseUrl}/',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        headers: {'Accept': 'application/json'},
      ),
    );

    final refreshDio = Dio(
      BaseOptions(baseUrl: '${AppConfig.apiBaseUrl}/'),
    );

    dio.interceptors.addAll([
      AuthInterceptor(secureStorage, deviceId),
      RefreshInterceptor(refreshDio, secureStorage, AppConfig.apiBaseUrl),
      ErrorInterceptor(),
      if (AppConfig.isDev)
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
        ),
    ]);
  }
}
