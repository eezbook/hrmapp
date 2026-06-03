import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_claim_model.freezed.dart';
part 'expense_claim_model.g.dart';

@freezed
abstract class ExpenseItemModel with _$ExpenseItemModel {
  const factory ExpenseItemModel({
    required int id,
    required String category,
    required String description,
    required double amount,
    required String date,
    String? receiptUrl,
    bool? requiresReceipt,
    bool? isPerDiem,
  }) = _ExpenseItemModel;

  factory ExpenseItemModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseItemModelFromJson(json);
}

@freezed
abstract class ExpenseClaimModel with _$ExpenseClaimModel {
  const factory ExpenseClaimModel({
    required int id,
    required String title,
    required double total,
    required String status,
    required List<ExpenseItemModel> items,
    int? travelRequestId,
    String? travelRequestDestination,
    String? createdAt,
    String? submittedAt,
    double? budgetAmount,
  }) = _ExpenseClaimModel;

  factory ExpenseClaimModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseClaimModelFromJson(json);
}

@freezed
abstract class ExpenseCategoryModel with _$ExpenseCategoryModel {
  const factory ExpenseCategoryModel({
    required int id,
    required String name,
    required bool requiresReceipt,
  }) = _ExpenseCategoryModel;

  factory ExpenseCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseCategoryModelFromJson(json);
}
