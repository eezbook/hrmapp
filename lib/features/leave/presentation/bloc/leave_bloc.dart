import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/sync/sync_queue_service.dart';
import '../../domain/repositories/leave_repository.dart';
import 'leave_event.dart';
import 'leave_state.dart';

class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
  final LeaveRepository _repository;

  LeaveBloc(this._repository) : super(LeaveInitial()) {
    on<LoadBalance>(_onLoadBalance);
    on<LoadRequests>(_onLoadRequests);
    on<LoadMoreRequests>(_onLoadMoreRequests);
    on<RefreshRequests>(_onRefreshRequests);
    on<ApplyLeave>(_onApplyLeave);
    on<CancelRequest>(_onCancelRequest);
    on<LoadApprovals>(_onLoadApprovals);
    on<LoadMoreApprovals>(_onLoadMoreApprovals);
    on<ApproveLeave>(_onApprove);
    on<RejectLeave>(_onReject);
  }

  Future<void> _onLoadBalance(
    LoadBalance event,
    Emitter<LeaveState> emit,
  ) async {
    emit(LeaveLoading());
    final result = await _repository.getBalance();
    result.fold(
      (f) => emit(LeaveError(f)),
      (balances) => emit(BalanceLoaded(balances)),
    );
  }

  Future<void> _onLoadRequests(
    LoadRequests event,
    Emitter<LeaveState> emit,
  ) async {
    emit(LeaveLoading());
    final result =
        await _repository.getRequests(status: event.status, page: 1);
    result.fold(
      (f) => emit(LeaveError(f)),
      (p) => emit(RequestsLoaded(p.items, hasMore: p.hasMore, currentPage: 1)),
    );
  }

  Future<void> _onLoadMoreRequests(
    LoadMoreRequests event,
    Emitter<LeaveState> emit,
  ) async {
    final current = state;
    if (current is! RequestsLoaded || !current.hasMore) return;
    emit(LeaveLoadingMore(current.requests));
    final result = await _repository.getRequests(
      status: event.status,
      page: current.currentPage + 1,
    );
    result.fold(
      (f) => emit(LeaveError(f)),
      (p) => emit(RequestsLoaded(
        [...current.requests, ...p.items],
        hasMore: p.hasMore,
        currentPage: p.currentPage,
      )),
    );
  }

  Future<void> _onRefreshRequests(
    RefreshRequests event,
    Emitter<LeaveState> emit,
  ) async {
    final result =
        await _repository.getRequests(status: event.status, page: 1);
    result.fold(
      (f) => emit(LeaveError(f)),
      (p) => emit(RequestsLoaded(p.items, hasMore: p.hasMore, currentPage: 1)),
    );
  }

  Future<void> _onApplyLeave(
    ApplyLeave event,
    Emitter<LeaveState> emit,
  ) async {
    final isOnline = await getIt<ConnectivityService>().isOnline();
    if (!isOnline) {
      await getIt<SyncQueueService>().addToQueue('leave_apply', event.params);
      emit(const LeaveApplyOfflineQueued(
        message: 'Leave request saved offline. Will sync when connected.',
      ));
      return;
    }

    emit(LeaveLoading());
    final result = await _repository.applyLeave(event.params);
    result.fold(
      (f) => emit(LeaveError(f)),
      (req) => emit(AppliedSuccess(req)),
    );
  }

  Future<void> _onCancelRequest(
    CancelRequest event,
    Emitter<LeaveState> emit,
  ) async {
    emit(LeaveLoading());
    final result = await _repository.cancelRequest(event.id);
    result.fold(
      (f) => emit(LeaveError(f)),
      (_) => emit(CancelledSuccess()),
    );
  }

  Future<void> _onLoadApprovals(
    LoadApprovals event,
    Emitter<LeaveState> emit,
  ) async {
    emit(LeaveLoading());
    final result =
        await _repository.getApprovals(status: event.status, page: 1);
    result.fold(
      (f) => emit(LeaveError(f)),
      (p) => emit(
          ApprovalsLoaded(p.items, hasMore: p.hasMore, currentPage: 1)),
    );
  }

  Future<void> _onLoadMoreApprovals(
    LoadMoreApprovals event,
    Emitter<LeaveState> emit,
  ) async {
    final current = state;
    if (current is! ApprovalsLoaded || !current.hasMore) return;
    emit(LeaveLoadingMore(current.approvals));
    final result = await _repository.getApprovals(
      status: event.status,
      page: current.currentPage + 1,
    );
    result.fold(
      (f) => emit(LeaveError(f)),
      (p) => emit(ApprovalsLoaded(
        [...current.approvals, ...p.items],
        hasMore: p.hasMore,
        currentPage: p.currentPage,
      )),
    );
  }

  Future<void> _onApprove(
    ApproveLeave event,
    Emitter<LeaveState> emit,
  ) async {
    final result = await _repository.approveRequest(event.id);
    result.fold(
      (f) => emit(LeaveError(f)),
      (_) => emit(ApprovalActionSuccess()),
    );
  }

  Future<void> _onReject(
    RejectLeave event,
    Emitter<LeaveState> emit,
  ) async {
    final result =
        await _repository.rejectRequest(event.id, event.comment);
    result.fold(
      (f) => emit(LeaveError(f)),
      (_) => emit(ApprovalActionSuccess()),
    );
  }
}
