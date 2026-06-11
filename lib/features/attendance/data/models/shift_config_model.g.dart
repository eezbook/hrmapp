// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShiftConfigModel _$ShiftConfigModelFromJson(Map<String, dynamic> json) =>
    _ShiftConfigModel(
      morningShiftStart: json['morningShiftStart'] as String?,
      morningShiftEnd: json['morningShiftEnd'] as String?,
      eveningShiftStart: json['eveningShiftStart'] as String?,
      eveningShiftEnd: json['eveningShiftEnd'] as String?,
      lateRelaxationMinutes:
          (json['lateRelaxationMinutes'] as num?)?.toInt() ?? 10,
      latePenaltyAmount: (json['latePenaltyAmount'] as num?)?.toDouble() ?? 0.0,
      latePenaltyType: (json['latePenaltyType'] as num?)?.toInt() ?? 1,
      absentDeductionAmount:
          (json['absentDeductionAmount'] as num?)?.toDouble() ?? 0.0,
      absentDeductionType: (json['absentDeductionType'] as num?)?.toInt() ?? 1,
      employeeShiftType: (json['employeeShiftType'] as num?)?.toInt(),
      effectiveShiftName: json['effectiveShiftName'] as String?,
      effectiveShiftStart: json['effectiveShiftStart'] as String?,
      effectiveShiftEnd: json['effectiveShiftEnd'] as String?,
    );

Map<String, dynamic> _$ShiftConfigModelToJson(_ShiftConfigModel instance) =>
    <String, dynamic>{
      'morningShiftStart': instance.morningShiftStart,
      'morningShiftEnd': instance.morningShiftEnd,
      'eveningShiftStart': instance.eveningShiftStart,
      'eveningShiftEnd': instance.eveningShiftEnd,
      'lateRelaxationMinutes': instance.lateRelaxationMinutes,
      'latePenaltyAmount': instance.latePenaltyAmount,
      'latePenaltyType': instance.latePenaltyType,
      'absentDeductionAmount': instance.absentDeductionAmount,
      'absentDeductionType': instance.absentDeductionType,
      'employeeShiftType': instance.employeeShiftType,
      'effectiveShiftName': instance.effectiveShiftName,
      'effectiveShiftStart': instance.effectiveShiftStart,
      'effectiveShiftEnd': instance.effectiveShiftEnd,
    };
