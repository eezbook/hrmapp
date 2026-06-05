import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_request_model.freezed.dart';
part 'leave_request_model.g.dart';

@freezed
abstract class ApprovalStepModel with _$ApprovalStepModel {
  const factory ApprovalStepModel({
    required int level,
    required String approverName,
    required String status,
    String? comment,
    String? decidedAt,
  }) = _ApprovalStepModel;

  factory ApprovalStepModel.fromJson(Map<String, dynamic> json) =>
      _$ApprovalStepModelFromJson(json);
}

@freezed
abstract class LeaveRequestModel with _$LeaveRequestModel {
  const factory LeaveRequestModel({
    required int id,
    required String leaveTypeName,
    required String startDate,
    required String endDate,
    @Default(0.0) double days,
    required String status,
    required String reason,
    String? documentUrl,
    String? cancelledAt,
    String? createdAt,
    bool? isHalfDay,
    String? halfDaySession,
    List<ApprovalStepModel>? approvalTrail,
    String? employeeName,
    String? employeePhoto,
    String? leaveTypeCode,
  }) = _LeaveRequestModel;

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveRequestModelFromJson(json);
}
