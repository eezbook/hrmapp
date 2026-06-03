import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? photo;
  final String? designation;
  final String? department;
  final String? employeeCode;
  final String? phone;
  final String? role;
  final String? joinDate;

  const Employee({
    required this.id,
    required this.name,
    required this.email,
    this.photo,
    this.designation,
    this.department,
    this.employeeCode,
    this.phone,
    this.role,
    this.joinDate,
  });

  @override
  List<Object?> get props => [id, email];
}
