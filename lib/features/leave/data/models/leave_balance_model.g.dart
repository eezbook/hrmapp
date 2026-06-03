// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_balance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaveBalanceModel _$LeaveBalanceModelFromJson(Map<String, dynamic> json) =>
    _LeaveBalanceModel(
      id: (json['id'] as num).toInt(),
      leaveTypeName: json['leaveTypeName'] as String,
      leaveTypeCode: json['leaveTypeCode'] as String,
      allocated: (json['allocated'] as num).toDouble(),
      used: (json['used'] as num).toDouble(),
      pending: (json['pending'] as num).toDouble(),
      remaining: (json['remaining'] as num).toDouble(),
      color: json['color'] as String?,
    );

Map<String, dynamic> _$LeaveBalanceModelToJson(_LeaveBalanceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'leaveTypeName': instance.leaveTypeName,
      'leaveTypeCode': instance.leaveTypeCode,
      'allocated': instance.allocated,
      'used': instance.used,
      'pending': instance.pending,
      'remaining': instance.remaining,
      'color': instance.color,
    };
