// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthResponseModel _$AuthResponseModelFromJson(Map<String, dynamic> json) =>
    _AuthResponseModel(
      employee: EmployeeModel.fromJson(
        json['employee'] as Map<String, dynamic>,
      ),
      hrmPermissions:
          (json['hrmPermissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String?,
    );

Map<String, dynamic> _$AuthResponseModelToJson(_AuthResponseModel instance) =>
    <String, dynamic>{
      'employee': instance.employee,
      'hrmPermissions': instance.hrmPermissions,
      'token': instance.token,
      'refreshToken': instance.refreshToken,
    };
