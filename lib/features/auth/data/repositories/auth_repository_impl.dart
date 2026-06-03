import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/permissions/hrm_permissions.dart';
import '../../../../core/storage/hive_storage.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/employee.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/employee_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final SecureStorage _secure;

  AuthRepositoryImpl(this._remote, this._secure);

  @override
  Future<Either<Failure, Employee>> login({
    required String email,
    required String password,
    required String deviceId,
    required String deviceName,
    required String deviceType,
    String? fcmToken,
  }) async {
    try {
      final response = await _remote.login({
        'email': email,
        'password': password,
        'device_id': deviceId,
        'device_name': deviceName,
        'device_type': deviceType,
        if (fcmToken != null) 'fcm_token': fcmToken,
      });
      final data = response.data!;
      await _secure.write(SecureKeys.authToken, data.token);
      if (data.refreshToken != null) {
        await _secure.write(SecureKeys.refreshToken, data.refreshToken!);
      }
      await _secure.write(SecureKeys.employeeId, data.employee.id.toString());
      await _secure.write(SecureKeys.employeeRole, data.employee.role ?? '');

      HrmPermissions.load(data.hrmPermissions);
      _cacheEmployee(data.employee);

      return Right(_mapEmployee(data.employee));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Employee>> getMe() async {
    try {
      final response = await _remote.getMe();
      final model = response.data!;
      _cacheEmployee(model);
      return Right(_mapEmployee(model));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remote.logout();
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    } finally {
      await _secure.deleteAll();
      HrmPermissions.clear();
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await _remote.forgotPassword({'email': email});
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      await _remote.verifyOtp({'email': email, 'otp': otp});
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      await _remote.resetPassword({
        'email': email,
        'otp': otp,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateDeviceToken(String token) async {
    try {
      await _remote.updateDeviceToken({'fcm_token': token});
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  void _cacheEmployee(EmployeeModel model) {
    HiveStorage.employee.put(HiveKeys.employee, model.toJson());
  }

  Employee _mapEmployee(EmployeeModel m) => Employee(
        id: m.id,
        name: m.name,
        email: m.email,
        photo: m.photo,
        designation: m.designation,
        department: m.department,
        employeeCode: m.employeeCode,
        phone: m.phone,
        role: m.role,
        joinDate: m.joinDate,
      );
}
