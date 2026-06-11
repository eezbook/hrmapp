import 'package:freezed_annotation/freezed_annotation.dart';

part 'overtime_model.freezed.dart';
part 'overtime_model.g.dart';

@freezed
abstract class OvertimeRequestModel with _$OvertimeRequestModel {
  const factory OvertimeRequestModel({
    required int id,
    required String date,
    required String startTime,
    required String endTime,
    @Default(0.0) double hours,
    @Default(0.0) double amount,
    required String status,
    required String reason,
    String? approverComment,
    String? createdAt,
    String? employeeName,
    String? employeePhoto,
    String? approvedBy,
  }) = _OvertimeRequestModel;

  factory OvertimeRequestModel.fromJson(Map<String, dynamic> json) =>
      _$OvertimeRequestModelFromJson(json);
}

@freezed
abstract class OvertimeSummaryModel with _$OvertimeSummaryModel {
  const factory OvertimeSummaryModel({
    @Default(0.0) double totalApprovedHours,
    @Default(0.0) double totalAmount,
    @Default(0) int pendingCount,
    @Default(true) bool overtimeEnabled,
    @Default(1.5) double normalRate,
    @Default(2.0) double holidayRate,
    @Default(4) int dailyThresholdHours,
    @Default(0.0) double usedHoursToday,
  }) = _OvertimeSummaryModel;

  factory OvertimeSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$OvertimeSummaryModelFromJson(json);
}
