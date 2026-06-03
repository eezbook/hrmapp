import 'package:equatable/equatable.dart';

class ExpenseItem extends Equatable {
  final int id;
  final String category;
  final String description;
  final double amount;
  final String date;
  final String? receiptUrl;
  final bool requiresReceipt;
  final bool isPerDiem;

  const ExpenseItem({
    required this.id,
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
    this.receiptUrl,
    this.requiresReceipt = false,
    this.isPerDiem = false,
  });

  @override
  List<Object?> get props => [id];
}

class ExpenseClaim extends Equatable {
  final int id;
  final String title;
  final double total;
  final String status;
  final List<ExpenseItem> items;
  final int? travelRequestId;
  final String? travelRequestDestination;
  final String? createdAt;
  final double? budgetAmount;

  const ExpenseClaim({
    required this.id,
    required this.title,
    required this.total,
    required this.status,
    required this.items,
    this.travelRequestId,
    this.travelRequestDestination,
    this.createdAt,
    this.budgetAmount,
  });

  double get remaining => (budgetAmount ?? 0) - total;

  @override
  List<Object?> get props => [id];
}
