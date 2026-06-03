// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CourseModel _$CourseModelFromJson(Map<String, dynamic> json) => _CourseModel(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  category: json['category'] as String,
  type: json['type'] as String,
  durationMinutes: (json['durationMinutes'] as num).toInt(),
  isMandatory: json['isMandatory'] as bool,
  thumbnailUrl: json['thumbnailUrl'] as String?,
  description: json['description'] as String?,
  deadlineDate: json['deadlineDate'] as String?,
  rating: (json['rating'] as num?)?.toDouble(),
  myProgress: (json['myProgress'] as num?)?.toDouble(),
  isEnrolled: json['isEnrolled'] as bool?,
  isCompleted: json['isCompleted'] as bool?,
  assessmentPassScore: (json['assessmentPassScore'] as num?)?.toInt(),
  assessmentAttemptsAllowed: (json['assessmentAttemptsAllowed'] as num?)
      ?.toInt(),
  hasAssessment: json['hasAssessment'] as bool?,
  contentUrl: json['contentUrl'] as String?,
);

Map<String, dynamic> _$CourseModelToJson(_CourseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'type': instance.type,
      'durationMinutes': instance.durationMinutes,
      'isMandatory': instance.isMandatory,
      'thumbnailUrl': instance.thumbnailUrl,
      'description': instance.description,
      'deadlineDate': instance.deadlineDate,
      'rating': instance.rating,
      'myProgress': instance.myProgress,
      'isEnrolled': instance.isEnrolled,
      'isCompleted': instance.isCompleted,
      'assessmentPassScore': instance.assessmentPassScore,
      'assessmentAttemptsAllowed': instance.assessmentAttemptsAllowed,
      'hasAssessment': instance.hasAssessment,
      'contentUrl': instance.contentUrl,
    };

_CertificateModel _$CertificateModelFromJson(Map<String, dynamic> json) =>
    _CertificateModel(
      id: (json['id'] as num).toInt(),
      courseId: (json['courseId'] as num).toInt(),
      courseName: json['courseName'] as String,
      issuedDate: json['issuedDate'] as String,
      expiryDate: json['expiryDate'] as String?,
      downloadUrl: json['downloadUrl'] as String?,
    );

Map<String, dynamic> _$CertificateModelToJson(_CertificateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'courseName': instance.courseName,
      'issuedDate': instance.issuedDate,
      'expiryDate': instance.expiryDate,
      'downloadUrl': instance.downloadUrl,
    };

_AssessmentQuestionModel _$AssessmentQuestionModelFromJson(
  Map<String, dynamic> json,
) => _AssessmentQuestionModel(
  id: (json['id'] as num).toInt(),
  question: json['question'] as String,
  options: (json['options'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$AssessmentQuestionModelToJson(
  _AssessmentQuestionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'question': instance.question,
  'options': instance.options,
};
