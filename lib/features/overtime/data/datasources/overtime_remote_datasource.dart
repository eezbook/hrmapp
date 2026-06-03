import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/api/api_response.dart';
import '../models/overtime_model.dart';

part 'overtime_remote_datasource.g.dart';

@RestApi()
abstract class OvertimeRemoteDataSource {
  factory OvertimeRemoteDataSource(Dio dio) = _OvertimeRemoteDataSource;

  @GET('overtime/requests')
  Future<ApiResponse<List<OvertimeRequestModel>>> getRequests({
    @Query('status') String? status,
    @Query('page') int? page,
  });

  @GET('overtime/summary')
  Future<ApiResponse<OvertimeSummaryModel>> getSummary();

  @POST('overtime/requests')
  Future<ApiResponse<OvertimeRequestModel>> createRequest(
    @Body() Map<String, dynamic> body,
  );

  @PUT('overtime/requests/{id}/cancel')
  Future<ApiResponse<void>> cancelRequest(
    @Path('id') int id,
  );

  @GET('overtime/approvals')
  Future<ApiResponse<List<OvertimeRequestModel>>> getApprovals();

  @POST('overtime/approvals/{id}/approve')
  Future<ApiResponse<void>> approveRequest(
    @Path('id') int id,
  );

  @POST('overtime/approvals/{id}/reject')
  Future<ApiResponse<void>> rejectRequest(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );
}
