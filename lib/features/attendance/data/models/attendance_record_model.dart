import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_record_model.freezed.dart';
part 'attendance_record_model.g.dart';

@freezed
abstract class AttendanceRecordModel with _$AttendanceRecordModel {
  const factory AttendanceRecordModel({
    required String date,
    required String dayOfWeek,
    String? checkIn,
    String? checkOut,
    @Default('unknown') String status,
    @Default('') String statusLabel,
    double? workingHours,
    @Default(0.0) double overtimeHours,
    String? remarks,
  }) = _AttendanceRecordModel;

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRecordModelFromJson(json);
}
