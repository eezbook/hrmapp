import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_model.freezed.dart';
part 'employee_model.g.dart';

@freezed
abstract class EmployeeModel with _$EmployeeModel {
  const factory EmployeeModel({
    required int id,
    required String name,
    required String email,
    String? photo,
    String? designation,
    String? department,
    String? employeeCode,
    String? phone,
    String? role,
    String? joinDate,
    String? companyName,
    List<String>? hrmPermissions,
  }) = _EmployeeModel;

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);
}
