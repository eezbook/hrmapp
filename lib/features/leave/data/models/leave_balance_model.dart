import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_balance_model.freezed.dart';
part 'leave_balance_model.g.dart';

@freezed
abstract class LeaveBalanceModel with _$LeaveBalanceModel {
  const factory LeaveBalanceModel({
    required int id,
    required String leaveTypeName,
    required String leaveTypeCode,
    @Default(0.0) double allocated,
    @Default(0.0) double used,
    @Default(0.0) double pending,
    @Default(0.0) double remaining,
    String? color,
  }) = _LeaveBalanceModel;

  factory LeaveBalanceModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveBalanceModelFromJson(json);
}
