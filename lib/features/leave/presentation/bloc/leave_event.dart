import 'package:equatable/equatable.dart';

abstract class LeaveEvent extends Equatable {
  const LeaveEvent();
  @override
  List<Object?> get props => [];
}

class LoadBalance extends LeaveEvent {}
class LoadRequests extends LeaveEvent {
  final String? status;
  const LoadRequests({this.status});
  @override
  List<Object?> get props => [status];
}
class LoadMoreRequests extends LeaveEvent {
  final String? status;
  const LoadMoreRequests({this.status});
  @override
  List<Object?> get props => [status];
}
class RefreshRequests extends LeaveEvent {
  final String? status;
  const RefreshRequests({this.status});
  @override
  List<Object?> get props => [status];
}
class ApplyLeave extends LeaveEvent {
  final Map<String, dynamic> params;
  const ApplyLeave(this.params);
  @override
  List<Object?> get props => [params];
}
class CancelRequest extends LeaveEvent {
  final int id;
  const CancelRequest(this.id);
  @override
  List<Object?> get props => [id];
}
class LoadApprovals extends LeaveEvent {
  final String? status;
  const LoadApprovals({this.status});
  @override
  List<Object?> get props => [status];
}
class LoadMoreApprovals extends LeaveEvent {
  final String? status;
  const LoadMoreApprovals({this.status});
}
class ApproveLeave extends LeaveEvent {
  final int id;
  const ApproveLeave(this.id);
  @override
  List<Object?> get props => [id];
}
class RejectLeave extends LeaveEvent {
  final int id;
  final String comment;
  const RejectLeave(this.id, this.comment);
  @override
  List<Object?> get props => [id];
}
