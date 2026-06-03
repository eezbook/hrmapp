// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardDataModel _$DashboardDataModelFromJson(Map<String, dynamic> json) =>
    _DashboardDataModel(
      leaveBalances: (json['leaveBalances'] as List<dynamic>?)
          ?.map((e) => LeaveBalanceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pendingLeaveCount: (json['pendingLeaveCount'] as num?)?.toInt(),
      pendingApprovalsCount: (json['pendingApprovalsCount'] as num?)?.toInt(),
      mandatoryTrainingDue: (json['mandatoryTrainingDue'] as num?)?.toInt(),
      myLearningProgress: (json['myLearningProgress'] as num?)?.toDouble(),
      pendingExpenseClaimsCount: (json['pendingExpenseClaimsCount'] as num?)
          ?.toInt(),
      nearestTrainingDeadline: json['nearestTrainingDeadline'] as String?,
      nearestTrainingTitle: json['nearestTrainingTitle'] as String?,
    );

Map<String, dynamic> _$DashboardDataModelToJson(_DashboardDataModel instance) =>
    <String, dynamic>{
      'leaveBalances': instance.leaveBalances,
      'pendingLeaveCount': instance.pendingLeaveCount,
      'pendingApprovalsCount': instance.pendingApprovalsCount,
      'mandatoryTrainingDue': instance.mandatoryTrainingDue,
      'myLearningProgress': instance.myLearningProgress,
      'pendingExpenseClaimsCount': instance.pendingExpenseClaimsCount,
      'nearestTrainingDeadline': instance.nearestTrainingDeadline,
      'nearestTrainingTitle': instance.nearestTrainingTitle,
    };
