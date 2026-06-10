import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/sync/sync_queue_service.dart';
import '../../data/datasources/overtime_remote_datasource.dart';
import '../../data/models/overtime_model.dart';

abstract class OvertimeState extends Equatable {
  const OvertimeState();
  @override
  List<Object?> get props => [];
}

class OvertimeLoading extends OvertimeState {}

class OvertimeLoaded extends OvertimeState {
  final List<OvertimeRequestModel> requests;
  final OvertimeSummaryModel? summary;
  final String? statusFilter;
  const OvertimeLoaded(this.requests, {this.summary, this.statusFilter});
  @override
  List<Object?> get props => [requests, summary, statusFilter];
}

class ApprovalsLoaded extends OvertimeState {
  final List<OvertimeRequestModel> approvals;
  const ApprovalsLoaded(this.approvals);
  @override
  List<Object?> get props => [approvals];
}

class AppliedSuccess extends OvertimeState {}
class OvertimeActionSuccess extends OvertimeState {}

class OvertimeError extends OvertimeState {
  final Failure failure;
  const OvertimeError(this.failure);
  @override
  List<Object?> get props => [failure];
}

class OtOfflineQueued extends OvertimeState {
  final String message;
  const OtOfflineQueued({required this.message});
  @override
  List<Object?> get props => [message];
}

class OvertimeCubit extends Cubit<OvertimeState> {
  final OvertimeRemoteDataSource _remote;

  OvertimeCubit(this._remote) : super(OvertimeLoading());

  Future<void> loadRequests({String? status}) async {
    emit(OvertimeLoading());
    try {
      final requestsFuture = _remote.getRequests(status: status);
      final summaryFuture = _remote.getSummary();
      final requestsRes = await requestsFuture;
      final summaryRes = await summaryFuture;
      emit(OvertimeLoaded(
        requestsRes.data ?? [],
        summary: summaryRes.data,
        statusFilter: status,
      ));
    } catch (e) {
      emit(OvertimeError(ErrorHandler.handle(e)));
    }
  }

  Future<void> applyOvertime(Map<String, dynamic> params) async {
    final isOnline = await getIt<ConnectivityService>().isOnline();
    if (!isOnline) {
      await getIt<SyncQueueService>().addToQueue('ot_request', params);
      emit(const OtOfflineQueued(
        message: 'Overtime request saved offline. Will sync when connected.',
      ));
      return;
    }

    emit(OvertimeLoading());
    try {
      await _remote.createRequest(params);
      emit(AppliedSuccess());
    } catch (e) {
      emit(OvertimeError(ErrorHandler.handle(e)));
    }
  }

  Future<void> cancelRequest(int id) async {
    try {
      await _remote.cancelRequest(id);
      emit(OvertimeActionSuccess());
    } catch (e) {
      emit(OvertimeError(ErrorHandler.handle(e)));
    }
  }

  Future<void> loadApprovals() async {
    emit(OvertimeLoading());
    try {
      final res = await _remote.getApprovals();
      emit(ApprovalsLoaded(res.data ?? []));
    } catch (e) {
      emit(OvertimeError(ErrorHandler.handle(e)));
    }
  }

  Future<void> approveRequest(int id) async {
    try {
      await _remote.approveRequest(id);
      emit(OvertimeActionSuccess());
    } catch (e) {
      emit(OvertimeError(ErrorHandler.handle(e)));
    }
  }

  Future<void> rejectRequest(int id, String comment) async {
    try {
      await _remote.rejectRequest(id, {'comment': comment});
      emit(OvertimeActionSuccess());
    } catch (e) {
      emit(OvertimeError(ErrorHandler.handle(e)));
    }
  }
}
