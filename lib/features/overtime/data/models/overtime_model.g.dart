// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overtime_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OvertimeRequestModel _$OvertimeRequestModelFromJson(
  Map<String, dynamic> json,
) => _OvertimeRequestModel(
  id: (json['id'] as num).toInt(),
  date: json['date'] as String,
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String,
  hours: (json['hours'] as num?)?.toDouble() ?? 0.0,
  amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
  status: json['status'] as String,
  reason: json['reason'] as String,
  approverComment: json['approverComment'] as String?,
  createdAt: json['createdAt'] as String?,
  employeeName: json['employeeName'] as String?,
  employeePhoto: json['employeePhoto'] as String?,
  approvedBy: json['approvedBy'] as String?,
);

Map<String, dynamic> _$OvertimeRequestModelToJson(
  _OvertimeRequestModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
  'hours': instance.hours,
  'amount': instance.amount,
  'status': instance.status,
  'reason': instance.reason,
  'approverComment': instance.approverComment,
  'createdAt': instance.createdAt,
  'employeeName': instance.employeeName,
  'employeePhoto': instance.employeePhoto,
  'approvedBy': instance.approvedBy,
};

_OvertimeSummaryModel _$OvertimeSummaryModelFromJson(
  Map<String, dynamic> json,
) => _OvertimeSummaryModel(
  totalApprovedHours: (json['totalApprovedHours'] as num?)?.toDouble() ?? 0.0,
  totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
  pendingCount: (json['pendingCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$OvertimeSummaryModelToJson(
  _OvertimeSummaryModel instance,
) => <String, dynamic>{
  'totalApprovedHours': instance.totalApprovedHours,
  'totalAmount': instance.totalAmount,
  'pendingCount': instance.pendingCount,
};
