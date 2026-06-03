import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../leave/data/models/leave_balance_model.dart';

part 'dashboard_data_model.freezed.dart';
part 'dashboard_data_model.g.dart';

@freezed
abstract class DashboardDataModel with _$DashboardDataModel {
  const factory DashboardDataModel({
    List<LeaveBalanceModel>? leaveBalances,
    int? pendingLeaveCount,
    int? pendingApprovalsCount,
    int? mandatoryTrainingDue,
    double? myLearningProgress,
    int? pendingExpenseClaimsCount,
    String? nearestTrainingDeadline,
    String? nearestTrainingTitle,
  }) = _DashboardDataModel;

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataModelFromJson(json);
}
