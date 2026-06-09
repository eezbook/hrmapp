import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../../features/attendance/data/datasources/attendance_remote_datasource.dart';
import '../../features/leave/data/datasources/leave_remote_datasource.dart';
import '../../features/overtime/data/datasources/overtime_remote_datasource.dart';

class SyncQueueService {
  static const _uuid = Uuid();

  Future<void> addToQueue(String action, Map<String, dynamic> payload) async {
    final id = _uuid.v4();
    await GetIt.instance<AppDatabase>().insertPendingAction({
      'id': id,
      'action': action,
      'payload': jsonEncode(payload),
      'created_at': DateTime.now().toIso8601String(),
      'retry_count': 0,
      'last_error': '',
      'synced_at': null,
    });
  }

  Future<void> processPendingQueue() async {
    final rows = await GetIt.instance<AppDatabase>().getPendingActions();
    for (final row in rows) {
      final id = row['id'] as String;
      final action = row['action'] as String;
      final payload =
          jsonDecode(row['payload'] as String) as Map<String, dynamic>;
      try {
        await _dispatchAction(action, payload);
        await GetIt.instance<AppDatabase>().markSynced(id);
      } catch (e) {
        await GetIt.instance<AppDatabase>().incrementRetry(id, e.toString());
        debugPrint('[SyncQueue] Failed to sync $id: $e');
      }
    }
  }

  Future<void> _dispatchAction(
    String action,
    Map<String, dynamic> payload,
  ) async {
    switch (action) {
      case 'attendance_checkin':
        // checkIn(Map<String, dynamic> body) — payload: latitude, longitude, location_type
        await GetIt.instance<AttendanceRemoteDataSource>().checkIn(payload);
        break;
      case 'attendance_checkout':
        // checkOut(Map<String, dynamic> body) — payload: latitude, longitude, location_type
        await GetIt.instance<AttendanceRemoteDataSource>().checkOut(payload);
        break;
      case 'leave_apply':
        // applyLeave(Map<String, dynamic> body) — payload: all leave apply fields
        await GetIt.instance<LeaveRemoteDataSource>().applyLeave(payload);
        break;
      case 'ot_request':
        // createRequest(Map<String, dynamic> body) — payload: date, start_time, end_time, hours, reason
        await GetIt.instance<OvertimeRemoteDataSource>().createRequest(payload);
        break;
      default:
        throw UnsupportedError('Unknown sync action: $action');
    }
  }

  Future<bool> get hasPendingItems async =>
      (await GetIt.instance<AppDatabase>().getPendingCount()) > 0;

  Future<int> get pendingCount async =>
      GetIt.instance<AppDatabase>().getPendingCount();
}
