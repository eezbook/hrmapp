import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/leave_request.dart';
import '../../domain/repositories/leave_repository.dart';

abstract class LeaveRequestsState {
  const LeaveRequestsState();
}

class LeaveRequestsInitial extends LeaveRequestsState {
  const LeaveRequestsInitial();
}

class LeaveRequestsLoading extends LeaveRequestsState {
  const LeaveRequestsLoading();
}

class LeaveRequestsLoadingMore extends LeaveRequestsState {
  final List<LeaveRequest> requests;
  const LeaveRequestsLoadingMore(this.requests);
}

class LeaveRequestsLoaded extends LeaveRequestsState {
  final List<LeaveRequest> requests;
  final bool hasMore;
  final int currentPage;
  const LeaveRequestsLoaded(
    this.requests, {
    this.hasMore = false,
    this.currentPage = 1,
  });
}

class LeaveRequestsError extends LeaveRequestsState {
  final String message;
  const LeaveRequestsError(this.message);
}

class LeaveRequestCancelled extends LeaveRequestsState {
  const LeaveRequestCancelled();
}

class LeaveRequestsCubit extends Cubit<LeaveRequestsState> {
  final LeaveRepository _repository;

  LeaveRequestsCubit(this._repository) : super(const LeaveRequestsInitial());

  Future<void> load({String? status}) async {
    emit(const LeaveRequestsLoading());
    final result = await _repository.getRequests(status: status, page: 1);
    result.fold(
      (f) => emit(LeaveRequestsError(f.message)),
      (p) => emit(LeaveRequestsLoaded(p.items, hasMore: p.hasMore, currentPage: 1)),
    );
  }

  Future<void> loadMore({String? status}) async {
    final current = state;
    if (current is! LeaveRequestsLoaded || !current.hasMore) return;
    emit(LeaveRequestsLoadingMore(current.requests));
    final result = await _repository.getRequests(
      status: status,
      page: current.currentPage + 1,
    );
    result.fold(
      (f) => emit(LeaveRequestsError(f.message)),
      (p) => emit(LeaveRequestsLoaded(
        [...current.requests, ...p.items],
        hasMore: p.hasMore,
        currentPage: p.currentPage,
      )),
    );
  }

  Future<void> refresh({String? status}) async {
    final result = await _repository.getRequests(status: status, page: 1);
    result.fold(
      (f) => emit(LeaveRequestsError(f.message)),
      (p) => emit(LeaveRequestsLoaded(p.items, hasMore: p.hasMore, currentPage: 1)),
    );
  }

  Future<void> cancel(int id) async {
    final result = await _repository.cancelRequest(id);
    result.fold(
      (f) => emit(LeaveRequestsError(f.message)),
      (_) => emit(const LeaveRequestCancelled()),
    );
  }
}
