import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/api/api_response.dart';
import '../models/attendance_record_model.dart';
import '../models/attendance_summary_model.dart';
import '../models/attendance_locations_model.dart';

part 'attendance_remote_datasource.g.dart';

@RestApi()
abstract class AttendanceRemoteDataSource {
  factory AttendanceRemoteDataSource(Dio dio) = _AttendanceRemoteDataSource;

  @GET('attendance/summary')
  Future<ApiResponse<AttendanceSummaryModel>> getSummary({
    @Query('month') int? month,
    @Query('year') int? year,
  });

  @GET('attendance/records')
  Future<ApiResponse<List<AttendanceRecordModel>>> getRecords({
    @Query('month') int? month,
    @Query('year') int? year,
  });

  @GET('attendance/today')
  Future<ApiResponse<AttendanceRecordModel>> getToday();

  @POST('attendance/check-in')
  Future<ApiResponse<AttendanceRecordModel>> checkIn(
    @Body() Map<String, dynamic> body,
  );

  @POST('attendance/check-out')
  Future<ApiResponse<AttendanceRecordModel>> checkOut(
    @Body() Map<String, dynamic> body,
  );

  @GET('attendance/location')
  Future<ApiResponse<AttendanceLocationsModel>> getAttendanceLocations();
}
