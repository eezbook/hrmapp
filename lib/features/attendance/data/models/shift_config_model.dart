import 'package:freezed_annotation/freezed_annotation.dart';

part 'shift_config_model.freezed.dart';
part 'shift_config_model.g.dart';

@freezed
abstract class ShiftConfigModel with _$ShiftConfigModel {
  const factory ShiftConfigModel({
    String? morningShiftStart,
    String? morningShiftEnd,
    String? eveningShiftStart,
    String? eveningShiftEnd,
    @Default(10) int lateRelaxationMinutes,
    @Default(0.0) double latePenaltyAmount,
    @Default(1) int latePenaltyType,
    @Default(0.0) double absentDeductionAmount,
    @Default(1) int absentDeductionType,
    int? employeeShiftType,
    String? effectiveShiftName,
    String? effectiveShiftStart,
    String? effectiveShiftEnd,
  }) = _ShiftConfigModel;

  factory ShiftConfigModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftConfigModelFromJson(json);
}
