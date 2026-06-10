import 'package:equatable/equatable.dart';

abstract class TravelEvent extends Equatable {
  const TravelEvent();
  @override
  List<Object?> get props => [];
}

class LoadTravelRequests extends TravelEvent {
  final String? status;
  const LoadTravelRequests({this.status});
  @override
  List<Object?> get props => [status];
}
class LoadMoreTravelRequests extends TravelEvent {
  final String? status;
  const LoadMoreTravelRequests({this.status});
}
class CreateTravelRequest extends TravelEvent {
  final Map<String, dynamic> params;
  const CreateTravelRequest(this.params);
}
class CancelTravelRequest extends TravelEvent {
  final int id;
  const CancelTravelRequest(this.id);
}
class LoadTravelApprovals extends TravelEvent {}
class ApproveTravelRequest extends TravelEvent {
  final int id;
  const ApproveTravelRequest(this.id);
}
class RejectTravelRequest extends TravelEvent {
  final int id;
  final String comment;
  const RejectTravelRequest(this.id, this.comment);
}
class LoadExpenseClaims extends TravelEvent {}
class LoadMoreExpenseClaims extends TravelEvent {}
class SubmitExpenseClaim extends TravelEvent {
  final int claimId;
  const SubmitExpenseClaim(this.claimId);
}
class ApproveExpense extends TravelEvent {
  final int id;
  const ApproveExpense(this.id);
}
class RejectExpense extends TravelEvent {
  final int id;
  final String comment;
  const RejectExpense(this.id, this.comment);
}
class LoadTravelRequestDetail extends TravelEvent {
  final int id;
  const LoadTravelRequestDetail(this.id);
  @override
  List<Object?> get props => [id];
}
class LoadExpenseClaimDetail extends TravelEvent {
  final int claimId;
  const LoadExpenseClaimDetail(this.claimId);
  @override
  List<Object?> get props => [claimId];
}
