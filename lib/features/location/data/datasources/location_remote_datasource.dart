import 'package:dio/dio.dart';
import '../../../../core/error/error_handler.dart';

class LocationRemoteDataSource {
  final Dio _dio;

  LocationRemoteDataSource(this._dio);

  // returns the raw API data map (allowLocationUpdate, home, office)
  Future<Map<String, dynamic>> getLocationInfo() async {
    final response = await _dio.get('attendance/location');
    final body = response.data as Map<String, dynamic>;
    return (body['data'] as Map<String, dynamic>?) ?? {};
  }

  Future<void> updateLocation({
    required double latitude,
    required double longitude,
    required int radius,
  }) async {
    final response = await _dio.post(
      'attendance/location/update',
      data: {
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
      },
    );
    final body = response.data as Map<String, dynamic>;
    if (body['success'] != true) {
      throw LocationUpdateException(
        body['message'] as String? ?? 'Failed to update location.',
      );
    }
  }
}

class LocationUpdateException implements Exception {
  final String message;
  const LocationUpdateException(this.message);
}
