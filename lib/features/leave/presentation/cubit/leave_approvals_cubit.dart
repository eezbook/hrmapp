import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/leave_request.dart';
import '../../domain/repositories/leave_repository.dart';

abstract class LeaveApprovalsState {
  const LeaveApprovalsState();
}

class LeaveApprovalsInitial extends LeaveApprovalsState {
  const LeaveApprovalsInitial();
}

class LeaveApprovalsLoading extends LeaveApprovalsState {
  const LeaveApprovalsLoading();
}

class LeaveApprovalsLoadingMore extends LeaveApprovalsState {
  final List<LeaveRequest> approvals;
  const LeaveApprovalsLoadingMore(this.approvals);
}

class LeaveApprovalsLoaded extends LeaveApprovalsState {
  final List<LeaveRequest> approvals;
  final bool hasMore;
  final int currentPage;
  const LeaveApprovalsLoaded(
    this.approvals, {
    this.hasMore = false,
    this.currentPage = 1,
  });
}

class LeaveApprovalsError extends LeaveApprovalsState {
  final String message;
  const LeaveApprovalsError(this.message);
}

class LeaveApprovalActionSuccess extends LeaveApprovalsState {
  const LeaveApprovalActionSuccess();
}

class LeaveApprovalsCubit extends Cubit<LeaveApprovalsState> {
  final LeaveRepository _repository;

  LeaveApprovalsCubit(this._repository) : super(const LeaveApprovalsInitial());

  Future<void> load({String? status}) async {
    emit(const LeaveApprovalsLoading());
    final result = await _repository.getApprovals(status: status, page: 1);
    result.fold(
      (f) => emit(LeaveApprovalsError(f.message)),
      (p) => emit(LeaveApprovalsLoaded(p.items, hasMore: p.hasMore, currentPage: 1)),
    );
  }

  Future<void> loadMore({String? status}) async {
    final current = state;
    if (current is! LeaveApprovalsLoaded || !current.hasMore) return;
    emit(LeaveApprovalsLoadingMore(current.approvals));
    final result = await _repository.getApprovals(
      status: status,
      page: current.currentPage + 1,
    );
    result.fold(
      (f) => emit(LeaveApprovalsError(f.message)),
      (p) => emit(LeaveApprovalsLoaded(
        [...current.approvals, ...p.items],
        hasMore: p.hasMore,
        currentPage: p.currentPage,
      )),
    );
  }

  Future<void> approve(int id) async {
    final result = await _repository.approveRequest(id);
    result.fold(
      (f) => emit(LeaveApprovalsError(f.message)),
      (_) => emit(const LeaveApprovalActionSuccess()),
    );
  }

  Future<void> reject(int id, String comment) async {
    final result = await _repository.rejectRequest(id, comment);
    result.fold(
      (f) => emit(LeaveApprovalsError(f.message)),
      (_) => emit(const LeaveApprovalActionSuccess()),
    );
  }
}
