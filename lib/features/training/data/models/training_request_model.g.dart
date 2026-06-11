// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrainingRequestModel _$TrainingRequestModelFromJson(
  Map<String, dynamic> json,
) => _TrainingRequestModel(
  id: (json['id'] as num).toInt(),
  trainingTitle: json['trainingTitle'] as String,
  trainingType: json['trainingType'] as String?,
  trainingLocation: json['trainingLocation'] as String?,
  startDate: json['startDate'] as String,
  endDate: json['endDate'] as String,
  totalDays: (json['totalDays'] as num).toInt(),
  advanceAmount: (json['advanceAmount'] as num?)?.toDouble() ?? 0.0,
  status: json['status'] as String,
  mainNarration: json['mainNarration'] as String?,
  createdAt: json['createdAt'] as String?,
  employeeName: json['employeeName'] as String?,
  employeePhoto: json['employeePhoto'] as String?,
);

Map<String, dynamic> _$TrainingRequestModelToJson(
  _TrainingRequestModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'trainingTitle': instance.trainingTitle,
  'trainingType': instance.trainingType,
  'trainingLocation': instance.trainingLocation,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'totalDays': instance.totalDays,
  'advanceAmount': instance.advanceAmount,
  'status': instance.status,
  'mainNarration': instance.mainNarration,
  'createdAt': instance.createdAt,
  'employeeName': instance.employeeName,
  'employeePhoto': instance.employeePhoto,
};
