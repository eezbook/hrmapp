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
    required double hours,
    required double amount,
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
    required double totalApprovedHours,
    required double totalAmount,
    required int pendingCount,
  }) = _OvertimeSummaryModel;

  factory OvertimeSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$OvertimeSummaryModelFromJson(json);
}
