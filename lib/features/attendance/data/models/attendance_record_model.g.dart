// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceRecordModel _$AttendanceRecordModelFromJson(
  Map<String, dynamic> json,
) => _AttendanceRecordModel(
  date: json['date'] as String,
  dayOfWeek: json['dayOfWeek'] as String,
  checkIn: json['checkIn'] as String?,
  checkOut: json['checkOut'] as String?,
  status: json['status'] as String? ?? 'unknown',
  statusLabel: json['statusLabel'] as String? ?? '',
  workingHours: (json['workingHours'] as num?)?.toDouble(),
  overtimeHours: (json['overtimeHours'] as num?)?.toDouble() ?? 0.0,
  remarks: json['remarks'] as String?,
);

Map<String, dynamic> _$AttendanceRecordModelToJson(
  _AttendanceRecordModel instance,
) => <String, dynamic>{
  'date': instance.date,
  'dayOfWeek': instance.dayOfWeek,
  'checkIn': instance.checkIn,
  'checkOut': instance.checkOut,
  'status': instance.status,
  'statusLabel': instance.statusLabel,
  'workingHours': instance.workingHours,
  'overtimeHours': instance.overtimeHours,
  'remarks': instance.remarks,
};
