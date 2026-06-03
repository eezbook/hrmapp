import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/api/api_response.dart';
import '../models/leave_balance_model.dart';
import '../models/leave_request_model.dart';
import '../models/leave_type_model.dart';

part 'leave_remote_datasource.g.dart';

@RestApi()
abstract class LeaveRemoteDataSource {
  factory LeaveRemoteDataSource(Dio dio) = _LeaveRemoteDataSource;

  @GET('leave/balance')
  Future<ApiResponse<List<LeaveBalanceModel>>> getBalance();

  @GET('leave/types')
  Future<ApiResponse<List<LeaveTypeModel>>> getLeaveTypes();

  @GET('leave/requests')
  Future<ApiResponse<List<LeaveRequestModel>>> getRequests({
    @Query('status') String? status,
    @Query('page') int? page,
  });

  @GET('leave/requests/{id}')
  Future<ApiResponse<LeaveRequestModel>> getRequest(
    @Path('id') int id,
  );

  @POST('leave/apply')
  Future<ApiResponse<LeaveRequestModel>> applyLeave(
    @Body() Map<String, dynamic> body,
  );

  @PUT('leave/requests/{id}/cancel')
  Future<ApiResponse<void>> cancelRequest(
    @Path('id') int id,
  );

  @GET('leave/approvals')
  Future<ApiResponse<List<LeaveRequestModel>>> getApprovals({
    @Query('status') String? status,
    @Query('page') int? page,
  });

  @POST('leave/approvals/{id}/approve')
  Future<ApiResponse<void>> approveRequest(
    @Path('id') int id,
  );

  @POST('leave/approvals/{id}/reject')
  Future<ApiResponse<void>> rejectRequest(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );

  @GET('leave/holidays')
  Future<ApiResponse<List<String>>> getPublicHolidays();

  @GET('leave/team-calendar')
  Future<ApiResponse<dynamic>> getTeamCalendar({
    @Query('month') required int month,
    @Query('year') required int year,
  });
}
