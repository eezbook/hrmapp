import 'package:equatable/equatable.dart';
import '../../domain/entities/employee.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final Employee employee;
  const AuthAuthenticated(this.employee);

  @override
  List<Object?> get props => [employee];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  final String? hrmCode;

  const AuthError(this.message, {this.hrmCode});

  @override
  List<Object?> get props => [message, hrmCode];
}
