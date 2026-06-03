import 'package:equatable/equatable.dart';

class ApprovalStep extends Equatable {
  final int level;
  final String approverName;
  final String status;
  final String? comment;
  final String? decidedAt;

  const ApprovalStep({
    required this.level,
    required this.approverName,
    required this.status,
    this.comment,
    this.decidedAt,
  });

  @override
  List<Object?> get props => [level, approverName];
}

class LeaveRequest extends Equatable {
  final int id;
  final String leaveTypeName;
  final String startDate;
  final String endDate;
  final double days;
  final String status;
  final String reason;
  final String? documentUrl;
  final String? createdAt;
  final bool isHalfDay;
  final String? halfDaySession;
  final List<ApprovalStep> approvalTrail;
  final String? employeeName;
  final String? employeePhoto;
  final String? leaveTypeCode;

  const LeaveRequest({
    required this.id,
    required this.leaveTypeName,
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.status,
    required this.reason,
    this.documentUrl,
    this.createdAt,
    this.isHalfDay = false,
    this.halfDaySession,
    this.approvalTrail = const [],
    this.employeeName,
    this.employeePhoto,
    this.leaveTypeCode,
  });

  bool get isPending => status == 'pending';

  @override
  List<Object?> get props => [id];
}
