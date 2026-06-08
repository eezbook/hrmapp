// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceSummaryModel _$AttendanceSummaryModelFromJson(
  Map<String, dynamic> json,
) => _AttendanceSummaryModel(
  month: (json['month'] as num).toInt(),
  year: (json['year'] as num).toInt(),
  monthName: json['monthName'] as String,
  workingDays: (json['workingDays'] as num?)?.toInt() ?? 0,
  presentDays: (json['presentDays'] as num?)?.toInt() ?? 0,
  absentDays: (json['absentDays'] as num?)?.toInt() ?? 0,
  lateDays: (json['lateDays'] as num?)?.toInt() ?? 0,
  halfDays: (json['halfDays'] as num?)?.toInt() ?? 0,
  leaveDays: (json['leaveDays'] as num?)?.toInt() ?? 0,
  travelDays: (json['travelDays'] as num?)?.toInt() ?? 0,
  holidayDays: (json['holidayDays'] as num?)?.toInt() ?? 0,
  weekendDays: (json['weekendDays'] as num?)?.toInt() ?? 0,
  totalWorkingHours: (json['totalWorkingHours'] as num?)?.toDouble() ?? 0.0,
  averageWorkingHours: (json['averageWorkingHours'] as num?)?.toDouble() ?? 0.0,
  attendancePercentage:
      (json['attendancePercentage'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$AttendanceSummaryModelToJson(
  _AttendanceSummaryModel instance,
) => <String, dynamic>{
  'month': instance.month,
  'year': instance.year,
  'monthName': instance.monthName,
  'workingDays': instance.workingDays,
  'presentDays': instance.presentDays,
  'absentDays': instance.absentDays,
  'lateDays': instance.lateDays,
  'halfDays': instance.halfDays,
  'leaveDays': instance.leaveDays,
  'travelDays': instance.travelDays,
  'holidayDays': instance.holidayDays,
  'weekendDays': instance.weekendDays,
  'totalWorkingHours': instance.totalWorkingHours,
  'averageWorkingHours': instance.averageWorkingHours,
  'attendancePercentage': instance.attendancePercentage,
};
