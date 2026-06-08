import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/api/api_response.dart';
import '../models/auth_response_model.dart';
import '../models/company_model.dart';
import '../models/employee_model.dart';

part 'auth_remote_datasource.g.dart';

@RestApi()
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio) = _AuthRemoteDataSource;

  @POST('auth/login')
  Future<ApiResponse<AuthResponseModel>> login(
    @Body() Map<String, dynamic> body,
  );

  @GET('auth/me')
  Future<ApiResponse<EmployeeModel>> getMe();

  @GET('auth/companies')
  Future<ApiResponse<List<CompanyModel>>> getCompanies();

  @POST('auth/refresh')
  Future<ApiResponse<AuthResponseModel>> refreshToken(
    @Body() Map<String, String> body,
  );

  @POST('auth/logout')
  Future<ApiResponse<void>> logout();

  @POST('auth/forgot-password')
  Future<ApiResponse<void>> forgotPassword(
    @Body() Map<String, String> body,
  );

  @POST('auth/verify-otp')
  Future<ApiResponse<void>> verifyOtp(
    @Body() Map<String, String> body,
  );

  @POST('auth/reset-password')
  Future<ApiResponse<void>> resetPassword(
    @Body() Map<String, String> body,
  );

  @PUT('auth/device-token')
  Future<ApiResponse<void>> updateDeviceToken(
    @Body() Map<String, String> body,
  );
}
