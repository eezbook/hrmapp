import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/services/location_service.dart';
import '../../data/datasources/attendance_remote_datasource.dart';
import '../../data/models/attendance_record_model.dart';
import '../../data/models/attendance_summary_model.dart';

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

// ── Cubit ─────────────────────────────────────────────────────────────────────

class AttendanceCubit extends Cubit<AttendanceState> {
  final AttendanceRemoteDataSource _remote;
  final LocationService _location;

  int _month = DateTime.now().month;
  int _year = DateTime.now().year;

  AttendanceCubit(this._remote, this._location)
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

  Future<void> _punch({required bool isCheckIn}) async {
    final current = state;
    if (current is! AttendanceLoaded) return;

    emit(current.copyWith(punchStatus: PunchStatus.loading, punchError: null));

    try {
      // 1. Fetch company location from system settings
      final locationResp = await _remote.getCompanyLocation();
      final company = locationResp.data;

      if (company == null) {
        emit(current.copyWith(
          punchStatus: PunchStatus.error,
          punchError:
              'Company location is not configured. Please contact your administrator.',
        ));
        return;
      }

      // 2. Get the employee's current GPS position
      final position = await _location.getCurrentPosition();

      // 3. Check geofence
      final withinRadius = _location.isWithinRadius(
        userLat: position.latitude,
        userLon: position.longitude,
        targetLat: company.latitude,
        targetLon: company.longitude,
        radiusMeters: company.radius,
      );

      if (!withinRadius) {
        emit(current.copyWith(
          punchStatus: PunchStatus.error,
          punchError:
              'You are outside the company premises. Please go within the location in order to check in or check out.',
        ));
        return;
      }

      // 4. Call the API
      final body = {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
      final resp =
          isCheckIn ? await _remote.checkIn(body) : await _remote.checkOut(body);

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
