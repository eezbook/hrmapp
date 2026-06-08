import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/employee.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  final String email;
  final String password;
  final String deviceId;
  final String deviceName;
  final String deviceType;
  const LoginParams({
    required this.email,
    required this.password,
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
  });
}

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<Failure, Employee>> call(LoginParams params) {
    return _repository.login(
      email: params.email,
      password: params.password,
      deviceId: params.deviceId,
      deviceName: params.deviceName,
      deviceType: params.deviceType,
    );
  }
}
