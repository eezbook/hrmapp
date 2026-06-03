import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/api/api_response.dart';
import '../models/expense_claim_model.dart';
import '../models/travel_request_model.dart';

part 'travel_remote_datasource.g.dart';

@RestApi()
abstract class TravelRemoteDataSource {
  factory TravelRemoteDataSource(Dio dio) = _TravelRemoteDataSource;

  @GET('travel/requests')
  Future<ApiResponse<List<TravelRequestModel>>> getTravelRequests({
    @Query('status') String? status,
    @Query('page') int? page,
  });

  @GET('travel/requests/{id}')
  Future<ApiResponse<TravelRequestModel>> getTravelRequest(
    @Path('id') int id,
  );

  @POST('travel/requests')
  Future<ApiResponse<TravelRequestModel>> createTravelRequest(
    @Body() Map<String, dynamic> body,
  );

  @PUT('travel/requests/{id}/cancel')
  Future<ApiResponse<void>> cancelTravelRequest(
    @Path('id') int id,
  );

  @GET('travel/approvals')
  Future<ApiResponse<List<TravelRequestModel>>> getTravelApprovals({
    @Query('status') String? status,
    @Query('page') int? page,
  });

  @POST('travel/approvals/{id}/approve')
  Future<ApiResponse<void>> approveTravelRequest(
    @Path('id') int id,
  );

  @POST('travel/approvals/{id}/reject')
  Future<ApiResponse<void>> rejectTravelRequest(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );

  @GET('expenses/claims')
  Future<ApiResponse<List<ExpenseClaimModel>>> getClaims({
    @Query('page') int? page,
  });

  @GET('expenses/claims/{id}')
  Future<ApiResponse<ExpenseClaimModel>> getClaim(
    @Path('id') int id,
  );

  @POST('expenses/claims')
  Future<ApiResponse<ExpenseClaimModel>> createClaim(
    @Body() Map<String, dynamic> body,
  );

  @PUT('expenses/claims/{id}/submit')
  Future<ApiResponse<void>> submitClaim(
    @Path('id') int id,
  );

  @POST('expenses/claims/{id}/items')
  Future<ApiResponse<ExpenseItemModel>> addExpenseItem(
    @Path('id') int claimId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('expenses/claims/{claimId}/items/{itemId}')
  Future<ApiResponse<void>> deleteExpenseItem(
    @Path('claimId') int claimId,
    @Path('itemId') int itemId,
  );

  @POST('expenses/claims/{id}/upload-receipt')
  @MultiPart()
  Future<ApiResponse<dynamic>> uploadReceipt(
    @Path('id') int claimId,
    @Part(name: 'receipt') MultipartFile receipt,
  );

  @POST('expenses/claims/{id}/export-pdf')
  Future<ApiResponse<dynamic>> exportPdf(
    @Path('id') int id,
  );

  @GET('expenses/categories')
  Future<ApiResponse<List<ExpenseCategoryModel>>> getCategories();

  @GET('expenses/approvals')
  Future<ApiResponse<List<ExpenseClaimModel>>> getExpenseApprovals({
    @Query('status') String? status,
    @Query('page') int? page,
  });

  @POST('expenses/approvals/{id}/approve')
  Future<ApiResponse<void>> approveExpense(@Path('id') int id);

  @POST('expenses/approvals/{id}/reject')
  Future<ApiResponse<void>> rejectExpense(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );
}
