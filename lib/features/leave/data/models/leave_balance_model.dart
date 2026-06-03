import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_balance_model.freezed.dart';
part 'leave_balance_model.g.dart';

@freezed
abstract class LeaveBalanceModel with _$LeaveBalanceModel {
  const factory LeaveBalanceModel({
    required int id,
    required String leaveTypeName,
    required String leaveTypeCode,
    required double allocated,
    required double used,
    required double pending,
    required double remaining,
    String? color,
  }) = _LeaveBalanceModel;

  factory LeaveBalanceModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveBalanceModelFromJson(json);
}
