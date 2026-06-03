import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/api/api_response.dart';
import '../models/course_model.dart';

part 'training_remote_datasource.g.dart';

@RestApi()
abstract class TrainingRemoteDataSource {
  factory TrainingRemoteDataSource(Dio dio) = _TrainingRemoteDataSource;

  @GET('training/courses')
  Future<ApiResponse<List<CourseModel>>> getCourses({
    @Query('category') String? category,
    @Query('search') String? search,
    @Query('page') int? page,
  });

  @GET('training/courses/{id}')
  Future<ApiResponse<CourseModel>> getCourse(@Path('id') int id);

  @POST('training/courses/{id}/enroll')
  Future<ApiResponse<void>> enrollCourse(@Path('id') int id);

  @POST('training/courses/{id}/progress')
  Future<ApiResponse<void>> updateProgress(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );

  @POST('training/courses/{id}/complete')
  Future<ApiResponse<CertificateModel?>> completeCourse(
    @Path('id') int id,
  );

  @GET('training/courses/{id}/assessment')
  Future<ApiResponse<List<AssessmentQuestionModel>>> getAssessment(
    @Path('id') int courseId,
  );

  @POST('training/assessments/{courseId}/submit')
  Future<ApiResponse<dynamic>> submitAssessment(
    @Path('courseId') int courseId,
    @Body() Map<String, dynamic> body,
  );

  @GET('training/certificates')
  Future<ApiResponse<List<CertificateModel>>> getCertificates();

  @GET('training/certificates/{id}/download')
  Future<ApiResponse<dynamic>> downloadCertificate(
    @Path('id') int id,
  );

  @GET('training/categories')
  Future<ApiResponse<List<String>>> getCategories();

  @GET('training/my-learning')
  Future<ApiResponse<dynamic>> getMyLearning();
}
