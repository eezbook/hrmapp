import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/sync/sync_queue_service.dart';
import '../../data/datasources/attendance_remote_datasource.dart';
import '../../data/models/attendance_record_model.dart';
import '../../data/models/attendance_summary_model.dart';
import '../../../travel/data/repositories/travel_repository_impl.dart';
import '../../../leave/domain/repositories/leave_repository.dart';

// ── Punch status ───────────────────────────────────────────────────────────────

enum PunchStatus { idle, loading, success, error }

// ── States ────────────────────────────────────────────────────────────────────

abstract class AttendanceState extends Equatable {
  const AttendanceState();
  @override
  List<Object?> get props => [];
}

class AttendanceLoading extends AttendanceState {
  const AttendanceLoading();
}

class AttendanceLoaded extends AttendanceState {
  final AttendanceSummaryModel summary;
  final List<AttendanceRecordModel> records;
  final AttendanceRecordModel? todayRecord;
  final int month;
  final int year;
  final PunchStatus punchStatus;
  final String? punchError;

  const AttendanceLoaded({
    required this.summary,
    required this.records,
    this.todayRecord,
    required this.month,
    required this.year,
    this.punchStatus = PunchStatus.idle,
    this.punchError,
  });

  AttendanceLoaded copyWith({
    AttendanceSummaryModel? summary,
    List<AttendanceRecordModel>? records,
    AttendanceRecordModel? todayRecord,
    int? month,
    int? year,
    PunchStatus? punchStatus,
    String? punchError,
  }) {
    return AttendanceLoaded(
      summary: summary ?? this.summary,
      records: records ?? this.records,
      todayRecord: todayRecord ?? this.todayRecord,
      month: month ?? this.month,
      year: year ?? this.year,
      punchStatus: punchStatus ?? this.punchStatus,
      punchError: punchError ?? this.punchError,
    );
  }

  @override
  List<Object?> get props => [
        summary,
        records,
        todayRecord,
        month,
        year,
        punchStatus,
        punchError,
      ];
}

class AttendanceError extends AttendanceState {
  final String message;
  const AttendanceError(this.message);
  @override
  List<Object?> get props => [message];
}

class AttendanceOfflineQueued extends AttendanceState {
  final String message;
  const AttendanceOfflineQueued({required this.message});
  @override
  List<Object?> get props => [message];
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class AttendanceCubit extends Cubit<AttendanceState> {
  final AttendanceRemoteDataSource _remote;
  final LocationService _location;
  final TravelRepository _travelRepo;
  final LeaveRepository _leaveRepo;

  int _month = DateTime.now().month;
  int _year = DateTime.now().year;

  AttendanceCubit(this._remote, this._location, this._travelRepo, this._leaveRepo)
      : super(const AttendanceLoading());

  Future<void> load({int? month, int? year}) async {
    _month = month ?? _month;
    _year = year ?? _year;
    emit(const AttendanceLoading());
    try {
      final results = await Future.wait([
        _remote.getSummary(month: _month, year: _year),
        _remote.getRecords(month: _month, year: _year),
      ]);

      AttendanceRecordModel? today;
      try {
        final todayResp = await _remote.getToday();
        today = todayResp.data;
      } catch (_) {}

      emit(AttendanceLoaded(
        summary: results[0].data as AttendanceSummaryModel,
        records: results[1].data as List<AttendanceRecordModel>,
        todayRecord: today,
        month: _month,
        year: _year,
      ));
    } catch (e) {
      emit(AttendanceError(ErrorHandler.handle(e).message));
    }
  }

  void prevMonth() {
    final dt = DateTime(_year, _month - 1);
    load(month: dt.month, year: dt.year);
  }

  void nextMonth() {
    final now = DateTime.now();
    final dt = DateTime(_year, _month + 1);
    if (dt.year > now.year || (dt.year == now.year && dt.month > now.month)) {
      return;
    }
    load(month: dt.month, year: dt.year);
  }

  bool get canGoNext {
    final now = DateTime.now();
    return !(_year == now.year && _month == now.month);
  }

  Future<void> checkIn() => _punch(isCheckIn: true);

  Future<void> checkOut() => _punch(isCheckIn: false);

  // Returns a blocking conflict message, or null when clear to punch.
  // Each sub-check catches its own errors so a network failure never prevents check-in.
  Future<String?> _checkConflicts() async {
    // 1. Leave check — fetch fresh today record; on_leave means approved full-day leave.
    // Half-day leave (status 'half_day' OR is_half_day flag) must NOT block check-in
    // because the employee works the other half of the day.
    try {
      final todayResp = await _remote.getToday();
      final today = todayResp.data;
      if (today != null && today.status == 'on_leave') {
        // Verify this is truly a full-day leave, not a half-day.
        // Fetch approved leaves and look for one covering today with is_half_day=true.
        bool isHalfDay = false;
        try {
          final leaveResult =
              await _leaveRepo.getRequests(status: 'approved', page: 1);
          leaveResult.fold(
            (_) {},
            (paginated) {
              final now = DateTime.now();
              final todayDate = DateTime(now.year, now.month, now.day);
              for (final leave in paginated.items) {
                try {
                  final start = DateTime.parse(leave.startDate);
                  final end = DateTime.parse(leave.endDate);
                  if (!todayDate.isBefore(DateTime(start.year, start.month, start.day)) &&
                      !todayDate.isAfter(DateTime(end.year, end.month, end.day)) &&
                      leave.isHalfDay) {
                    isHalfDay = true;
                    break;
                  }
                } catch (_) {}
              }
            },
          );
        } catch (_) {}

        if (!isHalfDay) {
          return 'You have an approved leave today. Attendance cannot be marked.';
        }
      }
    } catch (_) {}

    // 2. Travel check — any approved travel whose dates span today blocks punch.
    try {
      final result = await _travelRepo.getTravelRequests(status: 'approved');
      String? msg;
      result.fold(
        (_) {},
        (paginated) {
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          for (final travel in paginated.items) {
            try {
              final dep = DateTime.parse(travel.departureDate);
              final ret = DateTime.parse(travel.returnDate);
              final depDate = DateTime(dep.year, dep.month, dep.day);
              final retDate = DateTime(ret.year, ret.month, ret.day);
              if (!today.isBefore(depDate) && !today.isAfter(retDate)) {
                msg =
                    'You are on an approved travel to ${travel.destination}. '
                    'Attendance cannot be marked during travel.';
                break;
              }
            } catch (_) {}
          }
        },
      );
      if (msg != null) return msg;
    } catch (_) {}

    return null;
  }

  Future<void> _punch({required bool isCheckIn}) async {
    final current = state;
    if (current is! AttendanceLoaded) return;

    // Check connectivity before any API call
    final isOnline = await getIt<ConnectivityService>().isOnline();
    if (!isOnline) {
      double? lat;
      double? lon;
      try {
        final position = await _location.getCurrentPosition();
        lat = position.latitude;
        lon = position.longitude;
      } catch (_) {}

      await getIt<SyncQueueService>().addToQueue(
        isCheckIn ? 'attendance_checkin' : 'attendance_checkout',
        {
          'latitude': lat,
          'longitude': lon,
          // location_type cannot be determined offline (requires fetching configured
          // locations from server). Server should validate against coordinates on sync.
          'location_type': null,
        },
      );

      emit(AttendanceOfflineQueued(
        message: isCheckIn
            ? 'Check-in saved offline. Will sync when connected.'
            : 'Check-out saved offline. Will sync when connected.',
      ));
      // Restore the loaded state so the UI doesn't blank out
      emit(current.copyWith(punchStatus: PunchStatus.idle, punchError: null));
      return;
    }

    emit(current.copyWith(punchStatus: PunchStatus.loading, punchError: null));

    // Conflict checks run before GPS/location validation.
    final conflictMsg = await _checkConflicts();
    if (conflictMsg != null) {
      emit(current.copyWith(
        punchStatus: PunchStatus.error,
        punchError: conflictMsg,
      ));
      return;
    }

    try {
      // 1. Fetch both office and home locations
      final locationResp = await _remote.getAttendanceLocations();
      final locations = locationResp.data;

      if (locations == null || (locations.office == null && locations.home == null)) {
        emit(current.copyWith(
          punchStatus: PunchStatus.error,
          punchError: 'Attendance location is not configured. Please contact your administrator.',
        ));
        return;
      }

      // 2. Get the employee's current GPS position
      final position = await _location.getCurrentPosition();

      // 3. Check office first, then home
      String? matchedType;

      if (locations.office != null) {
        final withinOffice = _location.isWithinRadius(
          userLat: position.latitude,
          userLon: position.longitude,
          targetLat: locations.office!.latitude,
          targetLon: locations.office!.longitude,
          radiusMeters: locations.office!.radius,
        );
        if (withinOffice) matchedType = 'office';
      }

      if (matchedType == null && locations.home != null) {
        final withinHome = _location.isWithinRadius(
          userLat: position.latitude,
          userLon: position.longitude,
          targetLat: locations.home!.latitude,
          targetLon: locations.home!.longitude,
          radiusMeters: locations.home!.radius,
        );
        if (withinHome) matchedType = 'home';
      }

      if (matchedType == null) {
        final parts = <String>[];
        if (locations.office != null) parts.add(locations.office!.locationName.isNotEmpty ? locations.office!.locationName : 'company office');
        if (locations.home != null) parts.add(locations.home!.locationName.isNotEmpty ? locations.home!.locationName : 'home');
        final hint = parts.isNotEmpty ? ' (${parts.join(' or ')})' : '';
        emit(current.copyWith(
          punchStatus: PunchStatus.error,
          punchError: 'You are not within any allowed location$hint. Please go within the location to check in or check out.',
        ));
        return;
      }

      // 4. Call the API, passing which location type matched.
      // Include punch_time in local device time so the server stores PKT, not UTC.
      final now = DateTime.now();
      final punchTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
      final body = {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'location_type': matchedType,
        'punch_time': punchTime,
      };
      final resp = isCheckIn
          ? await _remote.checkIn(body)
          : await _remote.checkOut(body);

      // 5. Emit success with the fresh today record
      emit(current.copyWith(
        todayRecord: resp.data ?? current.todayRecord,
        punchStatus: PunchStatus.success,
        punchError: null,
      ));

      // 6. Silently reload monthly data to refresh the donut / calendar
      await load(month: _month, year: _year);
    } catch (e) {
      final latest = state;
      final errorMsg = e is LocationServiceException
          ? e.message
          : ErrorHandler.handle(e).message;
      if (latest is AttendanceLoaded) {
        emit(latest.copyWith(
          punchStatus: PunchStatus.error,
          punchError: errorMsg,
        ));
      }
    }
  }
}
