// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TravelRequestModel _$TravelRequestModelFromJson(Map<String, dynamic> json) =>
    _TravelRequestModel(
      id: (json['id'] as num).toInt(),
      purpose: json['purpose'] as String,
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      departureDate: json['departureDate'] as String,
      returnDate: json['returnDate'] as String,
      transportMode: json['transportMode'] as String,
      estimatedBudget: (json['estimatedBudget'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: json['createdAt'] as String?,
      employeeName: json['employeeName'] as String?,
      employeePhoto: json['employeePhoto'] as String?,
      budgetLimit: (json['budgetLimit'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$TravelRequestModelToJson(_TravelRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'purpose': instance.purpose,
      'origin': instance.origin,
      'destination': instance.destination,
      'departureDate': instance.departureDate,
      'returnDate': instance.returnDate,
      'transportMode': instance.transportMode,
      'estimatedBudget': instance.estimatedBudget,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'employeeName': instance.employeeName,
      'employeePhoto': instance.employeePhoto,
      'budgetLimit': instance.budgetLimit,
    };
