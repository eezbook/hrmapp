import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/api/api_response.dart';
import '../models/dashboard_data_model.dart';

part 'dashboard_remote_datasource.g.dart';

@RestApi()
abstract class DashboardRemoteDataSource {
  factory DashboardRemoteDataSource(Dio dio) = _DashboardRemoteDataSource;

  @GET('dashboard')
  Future<ApiResponse<DashboardDataModel>> getDashboard();
}
