import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_model.freezed.dart';
part 'course_model.g.dart';

@freezed
abstract class CourseModel with _$CourseModel {
  const factory CourseModel({
    required int id,
    required String title,
    required String category,
    required String type,
    @Default(0) int durationMinutes,
    required bool isMandatory,
    String? thumbnailUrl,
    String? description,
    String? deadlineDate,
    double? rating,
    double? myProgress,
    bool? isEnrolled,
    bool? isCompleted,
    int? assessmentPassScore,
    int? assessmentAttemptsAllowed,
    bool? hasAssessment,
    String? contentUrl,
  }) = _CourseModel;

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);
}

@freezed
abstract class CertificateModel with _$CertificateModel {
  const factory CertificateModel({
    required int id,
    required int courseId,
    required String courseName,
    required String issuedDate,
    String? expiryDate,
    String? downloadUrl,
  }) = _CertificateModel;

  factory CertificateModel.fromJson(Map<String, dynamic> json) =>
      _$CertificateModelFromJson(json);
}

@freezed
abstract class AssessmentQuestionModel with _$AssessmentQuestionModel {
  const factory AssessmentQuestionModel({
    required int id,
    required String question,
    required List<String> options,
  }) = _AssessmentQuestionModel;

  factory AssessmentQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$AssessmentQuestionModelFromJson(json);
}
