import 'package:equatable/equatable.dart';

class TravelRequest extends Equatable {
  final int id;
  final String purpose;
  final String origin;
  final String destination;
  final String departureDate;
  final String returnDate;
  final String transportMode;
  final double estimatedBudget;
  final String status;
  final String? createdAt;
  final String? employeeName;
  final String? employeePhoto;
  final double? budgetLimit;

  const TravelRequest({
    required this.id,
    required this.purpose,
    required this.origin,
    required this.destination,
    required this.departureDate,
    required this.returnDate,
    required this.transportMode,
    required this.estimatedBudget,
    required this.status,
    this.createdAt,
    this.employeeName,
    this.employeePhoto,
    this.budgetLimit,
  });

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';

  @override
  List<Object?> get props => [id];
}
