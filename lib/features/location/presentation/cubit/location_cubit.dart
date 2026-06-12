import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/services/location_service.dart';
import '../../data/datasources/location_remote_datasource.dart';

// ── States ────────────────────────────────────────────────────────────────────

abstract class LocationState extends Equatable {
  const LocationState();
  @override
  List<Object?> get props => [];
}

class LocationLoading extends LocationState {
  const LocationLoading();
}

class LocationLoaded extends LocationState {
  final bool allowUpdate;
  final double? currentLatitude;
  final double? currentLongitude;
  final String currentLocationName;

  const LocationLoaded({
    required this.allowUpdate,
    this.currentLatitude,
    this.currentLongitude,
    this.currentLocationName = 'Home',
  });

  @override
  List<Object?> get props => [
    allowUpdate,
    currentLatitude,
    currentLongitude,
    currentLocationName,
  ];
}

class LocationDetecting extends LocationState {
  const LocationDetecting();
}

class LocationSubmitting extends LocationState {
  const LocationSubmitting();
}

class LocationSubmitted extends LocationState {
  final double latitude;
  final double longitude;

  const LocationSubmitted({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

class LocationError extends LocationState {
  final String message;
  const LocationError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class LocationCubit extends Cubit<LocationState> {
  final LocationRemoteDataSource _remote;
  final LocationService _locationService;

  LocationCubit(this._remote, this._locationService)
      : super(const LocationLoading());

  Future<void> load() async {
    emit(const LocationLoading());
    try {
      final data = await _remote.getLocationInfo();
      final allowUpdate = (data['allowLocationUpdate'] as bool?) ?? false;
      final home = data['home'] as Map<String, dynamic>?;

      emit(LocationLoaded(
        allowUpdate: allowUpdate,
        currentLatitude: home != null
            ? (home['latitude'] as num?)?.toDouble()
            : null,
        currentLongitude: home != null
            ? (home['longitude'] as num?)?.toDouble()
            : null,
        currentLocationName:
            (home?['location_name'] as String?)?.isNotEmpty == true
                ? home!['location_name'] as String
                : 'Home',
      ));
    } catch (e) {
      emit(LocationError(ErrorHandler.handle(e).message));
    }
  }

  // detect GPS and submit in one step
  Future<void> detectAndSubmit() async {
    final current = state;
    if (current is! LocationLoaded || !current.allowUpdate) return;

    emit(const LocationDetecting());
    try {
      final position = await _locationService.getCurrentPosition();
      emit(const LocationSubmitting());
      await _remote.updateLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      emit(LocationSubmitted(
        latitude: position.latitude,
        longitude: position.longitude,
      ));
    } catch (e) {
      final msg = e is LocationServiceException
          ? e.message
          : e is LocationUpdateException
              ? e.message
              : ErrorHandler.handle(e).message;
      emit(LocationError(msg));
    }
  }

  // manual coordinates submit
  Future<void> submitManual({
    required double latitude,
    required double longitude,
  }) async {
    final current = state;
    if (current is! LocationLoaded || !current.allowUpdate) return;

    emit(const LocationSubmitting());
    try {
      await _remote.updateLocation(
        latitude: latitude,
        longitude: longitude,
      );
      emit(LocationSubmitted(
        latitude: latitude,
        longitude: longitude,
      ));
    } catch (e) {
      final msg = e is LocationUpdateException
          ? e.message
          : ErrorHandler.handle(e).message;
      emit(LocationError(msg));
    }
  }

  void clearError() {
    load();
  }
}
