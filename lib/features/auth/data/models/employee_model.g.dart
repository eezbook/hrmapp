// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EmployeeModel _$EmployeeModelFromJson(Map<String, dynamic> json) =>
    _EmployeeModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      photo: json['photo'] as String?,
      designation: json['designation'] as String?,
      department: json['department'] as String?,
      employeeCode: json['employeeCode'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String?,
      joinDate: json['joinDate'] as String?,
      companyName: json['companyName'] as String?,
      hrmPermissions: (json['hrmPermissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$EmployeeModelToJson(_EmployeeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'photo': instance.photo,
      'designation': instance.designation,
      'department': instance.department,
      'employeeCode': instance.employeeCode,
      'phone': instance.phone,
      'role': instance.role,
      'joinDate': instance.joinDate,
      'companyName': instance.companyName,
      'hrmPermissions': instance.hrmPermissions,
    };
