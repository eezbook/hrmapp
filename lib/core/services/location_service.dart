import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationServiceException(
        'Location services are disabled. Please enable GPS and try again.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationServiceException(
        'Location permission is permanently denied. Please enable it in app settings.',
      );
    }

    if (permission == LocationPermission.denied) {
      throw const LocationServiceException('Location permission denied.');
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    ).timeout(
      const Duration(seconds: 15),
      onTimeout: () => throw const LocationServiceException(
        'Location request timed out. Please try again.',
      ),
    );
  }

  bool isWithinRadius({
    required double userLat,
    required double userLon,
    required double targetLat,
    required double targetLon,
    required double radiusMeters,
  }) {
    final distance = Geolocator.distanceBetween(
      userLat,
      userLon,
      targetLat,
      targetLon,
    );
    return distance <= radiusMeters;
  }
}

class LocationServiceException implements Exception {
  final String message;
  const LocationServiceException(this.message);

  @override
  String toString() => message;
}
