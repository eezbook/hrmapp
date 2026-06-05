// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_claim_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExpenseItemModel _$ExpenseItemModelFromJson(Map<String, dynamic> json) =>
    _ExpenseItemModel(
      id: (json['id'] as num).toInt(),
      category: json['category'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      date: json['date'] as String,
      receiptUrl: json['receiptUrl'] as String?,
      requiresReceipt: json['requiresReceipt'] as bool?,
      isPerDiem: json['isPerDiem'] as bool?,
    );

Map<String, dynamic> _$ExpenseItemModelToJson(_ExpenseItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'description': instance.description,
      'amount': instance.amount,
      'date': instance.date,
      'receiptUrl': instance.receiptUrl,
      'requiresReceipt': instance.requiresReceipt,
      'isPerDiem': instance.isPerDiem,
    };

_ExpenseClaimModel _$ExpenseClaimModelFromJson(Map<String, dynamic> json) =>
    _ExpenseClaimModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => ExpenseItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      travelRequestId: (json['travelRequestId'] as num?)?.toInt(),
      travelRequestDestination: json['travelRequestDestination'] as String?,
      createdAt: json['createdAt'] as String?,
      submittedAt: json['submittedAt'] as String?,
      budgetAmount: (json['budgetAmount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ExpenseClaimModelToJson(_ExpenseClaimModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'total': instance.total,
      'status': instance.status,
      'items': instance.items,
      'travelRequestId': instance.travelRequestId,
      'travelRequestDestination': instance.travelRequestDestination,
      'createdAt': instance.createdAt,
      'submittedAt': instance.submittedAt,
      'budgetAmount': instance.budgetAmount,
    };

_ExpenseCategoryModel _$ExpenseCategoryModelFromJson(
  Map<String, dynamic> json,
) => _ExpenseCategoryModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  requiresReceipt: json['requiresReceipt'] as bool,
);

Map<String, dynamic> _$ExpenseCategoryModelToJson(
  _ExpenseCategoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'requiresReceipt': instance.requiresReceipt,
};
