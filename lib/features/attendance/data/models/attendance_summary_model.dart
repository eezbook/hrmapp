import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_summary_model.freezed.dart';
part 'attendance_summary_model.g.dart';

@freezed
abstract class AttendanceSummaryModel with _$AttendanceSummaryModel {
  const factory AttendanceSummaryModel({
    required int month,
    required int year,
    required String monthName,
    @Default(0) int workingDays,
    @Default(0) int presentDays,
    @Default(0) int absentDays,
    @Default(0) int lateDays,
    @Default(0) int halfDays,
    @Default(0) int leaveDays,
    @Default(0) int travelDays,
    @Default(0) int holidayDays,
    @Default(0) int weekendDays,
    @Default(0.0) double totalWorkingHours,
    @Default(0.0) double averageWorkingHours,
    @Default(0.0) double attendancePercentage,
  }) = _AttendanceSummaryModel;

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceSummaryModelFromJson(json);
}
