import 'package:freezed_annotation/freezed_annotation.dart';

part 'travel_request_model.freezed.dart';
part 'travel_request_model.g.dart';

@freezed
abstract class TravelRequestModel with _$TravelRequestModel {
  const factory TravelRequestModel({
    required int id,
    required String purpose,
    required String origin,
    required String destination,
    required String departureDate,
    required String returnDate,
    required String transportMode,
    @Default(0.0) double estimatedBudget,
    required String status,
    String? createdAt,
    String? employeeName,
    String? employeePhoto,
    double? budgetLimit,
  }) = _TravelRequestModel;

  factory TravelRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TravelRequestModelFromJson(json);
}
