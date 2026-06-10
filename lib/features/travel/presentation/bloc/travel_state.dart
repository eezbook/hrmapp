import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/expense_claim.dart';
import '../../domain/entities/travel_request.dart';

abstract class TravelState extends Equatable {
  const TravelState();
  @override
  List<Object?> get props => [];
}

class TravelInitial extends TravelState {}
class TravelLoading extends TravelState {}

class TravelRequestsLoaded extends TravelState {
  final List<TravelRequest> requests;
  final bool hasMore;
  final int currentPage;
  const TravelRequestsLoaded(this.requests, {this.hasMore = false, this.currentPage = 1});
  @override
  List<Object?> get props => [requests, hasMore];
}

class TravelApprovalsLoaded extends TravelState {
  final List<TravelRequest> approvals;
  const TravelApprovalsLoaded(this.approvals);
  @override
  List<Object?> get props => [approvals];
}

class ExpenseClaimsLoaded extends TravelState {
  final List<ExpenseClaim> claims;
  final bool hasMore;
  final int currentPage;
  const ExpenseClaimsLoaded(this.claims, {this.hasMore = false, this.currentPage = 1});
  @override
  List<Object?> get props => [claims, hasMore];
}

class ExpenseApprovalsLoaded extends TravelState {
  final List<ExpenseClaim> approvals;
  const ExpenseApprovalsLoaded(this.approvals);
}

class TravelRequestCreated extends TravelState {
  final TravelRequest request;
  const TravelRequestCreated(this.request);
}

class TravelRequestDetailLoaded extends TravelState {
  final TravelRequest request;
  const TravelRequestDetailLoaded(this.request);
  @override
  List<Object?> get props => [request];
}
class ExpenseClaimDetailLoaded extends TravelState {
  final ExpenseClaim claim;
  const ExpenseClaimDetailLoaded(this.claim);
  @override
  List<Object?> get props => [claim];
}
class ExpenseSubmitted extends TravelState {}
class TravelActionSuccess extends TravelState {}
class TravelError extends TravelState {
  final Failure failure;
  const TravelError(this.failure);
  @override
  List<Object?> get props => [failure];
}
