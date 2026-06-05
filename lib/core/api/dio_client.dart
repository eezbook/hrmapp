import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../storage/secure_storage.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';
import 'refresh_interceptor.dart';

class DioClient {
  late final Dio dio;

  DioClient(SecureStorage secureStorage, String deviceId) {
    // When running against a local WAMP virtual host from an Android emulator
    // or physical device, the request goes to an IP address (10.0.2.2 or a
    // LAN IP) but Apache needs to see the correct Host header to route to the
    // right virtual host (e.g. devacculyt.com). Injecting the Host header
    // here is the standard "virtual-host spoofing" trick for local dev —
    // it never runs in staging or production.
    final Map<String, dynamic> baseHeaders = {
      'Accept': 'application/json',
      if (AppConfig.isDev && (AppConfig.devHost?.isNotEmpty ?? false))
        'Host': AppConfig.devHost!,
    };

    dio = Dio(
      BaseOptions(
        baseUrl:        '${AppConfig.apiBaseUrl}/',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        headers:        baseHeaders,
      ),
    );

    final refreshDio = Dio(
      BaseOptions(
        baseUrl: '${AppConfig.apiBaseUrl}/',
        headers: baseHeaders,
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(secureStorage, deviceId),
      RefreshInterceptor(refreshDio, secureStorage, AppConfig.apiBaseUrl),
      ErrorInterceptor(),
      if (AppConfig.isDev)
        LogInterceptor(
          requestBody:  true,
          responseBody: true,
          error:        true,
        ),
    ]);
  }
}
