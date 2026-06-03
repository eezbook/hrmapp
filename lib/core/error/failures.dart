import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super(message: 'No internet connection');
}

class AuthFailure extends Failure {
  final String? hrmErrorCode;
  const AuthFailure({this.hrmErrorCode, super.message = 'Unauthorised'});

  @override
  List<Object?> get props => [message, hrmErrorCode];
}

class PermissionFailure extends Failure {
  final String hrmErrorCode;
  const PermissionFailure({
    required this.hrmErrorCode,
    super.message = 'Permission denied',
  });

  @override
  List<Object?> get props => [message, hrmErrorCode];
}

class ValidationFailure extends Failure {
  final Map<String, List<String>> errors;
  const ValidationFailure({
    this.errors = const {},
    super.message = 'Validation error',
  });

  @override
  List<Object?> get props => [message, errors];
}

class NotFoundFailure extends Failure {
  const NotFoundFailure() : super(message: 'Resource not found');
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error'});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error'});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.message = 'Unexpected error'});
}
