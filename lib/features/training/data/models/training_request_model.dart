import 'package:freezed_annotation/freezed_annotation.dart';

part 'training_request_model.freezed.dart';
part 'training_request_model.g.dart';

@freezed
abstract class TrainingRequestModel with _$TrainingRequestModel {
  const factory TrainingRequestModel({
    required int id,
    required String trainingTitle,
    String? trainingType,
    String? trainingLocation,
    required String startDate,
    required String endDate,
    required int totalDays,
    @Default(0.0) double advanceAmount,
    required String status,
    String? mainNarration,
    String? createdAt,
    String? employeeName,
    String? employeePhoto,
  }) = _TrainingRequestModel;

  factory TrainingRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TrainingRequestModelFromJson(json);
}
