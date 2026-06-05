// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApprovalStepModel _$ApprovalStepModelFromJson(Map<String, dynamic> json) =>
    _ApprovalStepModel(
      level: (json['level'] as num).toInt(),
      approverName: json['approverName'] as String,
      status: json['status'] as String,
      comment: json['comment'] as String?,
      decidedAt: json['decidedAt'] as String?,
    );

Map<String, dynamic> _$ApprovalStepModelToJson(_ApprovalStepModel instance) =>
    <String, dynamic>{
      'level': instance.level,
      'approverName': instance.approverName,
      'status': instance.status,
      'comment': instance.comment,
      'decidedAt': instance.decidedAt,
    };

_LeaveRequestModel _$LeaveRequestModelFromJson(Map<String, dynamic> json) =>
    _LeaveRequestModel(
      id: (json['id'] as num).toInt(),
      leaveTypeName: json['leaveTypeName'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      days: (json['days'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String,
      reason: json['reason'] as String,
      documentUrl: json['documentUrl'] as String?,
      cancelledAt: json['cancelledAt'] as String?,
      createdAt: json['createdAt'] as String?,
      isHalfDay: json['isHalfDay'] as bool?,
      halfDaySession: json['halfDaySession'] as String?,
      approvalTrail: (json['approvalTrail'] as List<dynamic>?)
          ?.map((e) => ApprovalStepModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      employeeName: json['employeeName'] as String?,
      employeePhoto: json['employeePhoto'] as String?,
      leaveTypeCode: json['leaveTypeCode'] as String?,
    );

Map<String, dynamic> _$LeaveRequestModelToJson(_LeaveRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'leaveTypeName': instance.leaveTypeName,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'days': instance.days,
      'status': instance.status,
      'reason': instance.reason,
      'documentUrl': instance.documentUrl,
      'cancelledAt': instance.cancelledAt,
      'createdAt': instance.createdAt,
      'isHalfDay': instance.isHalfDay,
      'halfDaySession': instance.halfDaySession,
      'approvalTrail': instance.approvalTrail,
      'employeeName': instance.employeeName,
      'employeePhoto': instance.employeePhoto,
      'leaveTypeCode': instance.leaveTypeCode,
    };
