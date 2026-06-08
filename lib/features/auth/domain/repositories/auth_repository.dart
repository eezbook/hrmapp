import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/company_model.dart';
import '../entities/employee.dart';

abstract class AuthRepository {
  Future<Either<Failure, Employee>> login({
    required String email,
    required String password,
    required String deviceId,
    required String deviceName,
    required String deviceType,
  });

  Future<Either<Failure, Employee>> getMe();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, void>> forgotPassword(String email);

  Future<Either<Failure, void>> verifyOtp({
    required String email,
    required String otp,
  });

  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  });

  Future<Either<Failure, void>> updateDeviceToken(String token);

  Future<Either<Failure, List<CompanyModel>>> getCompanies();

  Future<void> switchCompany(int companyId);
}
