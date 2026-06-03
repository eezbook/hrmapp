import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/leave_balance.dart';
import '../../domain/entities/leave_request.dart';

abstract class LeaveState extends Equatable {
  const LeaveState();
  @override
  List<Object?> get props => [];
}

class LeaveInitial extends LeaveState {}
class LeaveLoading extends LeaveState {}
class LeaveLoadingMore extends LeaveState {
  final List<LeaveRequest> currentItems;
  const LeaveLoadingMore(this.currentItems);
  @override
  List<Object?> get props => [currentItems];
}

class BalanceLoaded extends LeaveState {
  final List<LeaveBalance> balances;
  const BalanceLoaded(this.balances);
  @override
  List<Object?> get props => [balances];
}

class RequestsLoaded extends LeaveState {
  final List<LeaveRequest> requests;
  final bool hasMore;
  final int currentPage;
  const RequestsLoaded(this.requests, {this.hasMore = false, this.currentPage = 1});
  @override
  List<Object?> get props => [requests, hasMore];
}

class ApprovalsLoaded extends LeaveState {
  final List<LeaveRequest> approvals;
  final bool hasMore;
  final int currentPage;
  const ApprovalsLoaded(this.approvals, {this.hasMore = false, this.currentPage = 1});
  @override
  List<Object?> get props => [approvals, hasMore];
}

class AppliedSuccess extends LeaveState {
  final LeaveRequest request;
  const AppliedSuccess(this.request);
}

class CancelledSuccess extends LeaveState {}
class ApprovalActionSuccess extends LeaveState {}

class LeaveError extends LeaveState {
  final Failure failure;
  const LeaveError(this.failure);
  @override
  List<Object?> get props => [failure];
}
