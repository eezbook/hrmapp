// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaveTypeModel _$LeaveTypeModelFromJson(Map<String, dynamic> json) =>
    _LeaveTypeModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      code: json['code'] as String,
      requiresDocument: json['requiresDocument'] as bool,
      allowHalfDay: json['allowHalfDay'] as bool,
      maxDays: (json['maxDays'] as num).toInt(),
      color: json['color'] as String?,
    );

Map<String, dynamic> _$LeaveTypeModelToJson(_LeaveTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'requiresDocument': instance.requiresDocument,
      'allowHalfDay': instance.allowHalfDay,
      'maxDays': instance.maxDays,
      'color': instance.color,
    };
