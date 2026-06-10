import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/travel_repository_impl.dart';
import 'travel_event.dart';
import 'travel_state.dart';

class TravelBloc extends Bloc<TravelEvent, TravelState> {
  final TravelRepository _repository;

  TravelBloc(this._repository) : super(TravelInitial()) {
    on<LoadTravelRequests>(_onLoadRequests);
    on<LoadMoreTravelRequests>(_onLoadMoreRequests);
    on<CreateTravelRequest>(_onCreate);
    on<CancelTravelRequest>(_onCancel);
    on<LoadTravelApprovals>(_onLoadApprovals);
    on<ApproveTravelRequest>(_onApprove);
    on<RejectTravelRequest>(_onReject);
    on<LoadExpenseClaims>(_onLoadClaims);
    on<LoadMoreExpenseClaims>(_onLoadMoreClaims);
    on<SubmitExpenseClaim>(_onSubmitClaim);
    on<ApproveExpense>(_onApproveExpense);
    on<RejectExpense>(_onRejectExpense);
    on<LoadTravelRequestDetail>(_onLoadTravelDetail);
    on<LoadExpenseClaimDetail>(_onLoadExpenseDetail);
  }

  Future<void> _onLoadRequests(
      LoadTravelRequests event, Emitter<TravelState> emit) async {
    emit(TravelLoading());
    final result = await _repository.getTravelRequests(status: event.status);
    result.fold(
      (f) => emit(TravelError(f)),
      (p) => emit(TravelRequestsLoaded(p.items, hasMore: p.hasMore, currentPage: p.currentPage)),
    );
  }

  Future<void> _onLoadMoreRequests(
      LoadMoreTravelRequests event, Emitter<TravelState> emit) async {
    final current = state;
    if (current is! TravelRequestsLoaded || !current.hasMore) return;
    final result = await _repository.getTravelRequests(
      status: event.status,
      page: current.currentPage + 1,
    );
    result.fold(
      (f) => emit(TravelError(f)),
      (p) => emit(TravelRequestsLoaded(
        [...current.requests, ...p.items],
        hasMore: p.hasMore,
        currentPage: p.currentPage,
      )),
    );
  }

  Future<void> _onCreate(
      CreateTravelRequest event, Emitter<TravelState> emit) async {
    emit(TravelLoading());
    final result = await _repository.createTravelRequest(event.params);
    result.fold(
      (f) => emit(TravelError(f)),
      (r) => emit(TravelRequestCreated(r)),
    );
  }

  Future<void> _onCancel(
      CancelTravelRequest event, Emitter<TravelState> emit) async {
    final result = await _repository.cancelTravelRequest(event.id);
    result.fold(
      (f) => emit(TravelError(f)),
      (_) => emit(TravelActionSuccess()),
    );
  }

  Future<void> _onLoadApprovals(
      LoadTravelApprovals event, Emitter<TravelState> emit) async {
    emit(TravelLoading());
    final result = await _repository.getTravelApprovals();
    result.fold(
      (f) => emit(TravelError(f)),
      (items) => emit(TravelApprovalsLoaded(items)),
    );
  }

  Future<void> _onApprove(
      ApproveTravelRequest event, Emitter<TravelState> emit) async {
    final result = await _repository.approveTravelRequest(event.id);
    result.fold(
      (f) => emit(TravelError(f)),
      (_) => emit(TravelActionSuccess()),
    );
  }

  Future<void> _onReject(
      RejectTravelRequest event, Emitter<TravelState> emit) async {
    final result =
        await _repository.rejectTravelRequest(event.id, event.comment);
    result.fold(
      (f) => emit(TravelError(f)),
      (_) => emit(TravelActionSuccess()),
    );
  }

  Future<void> _onLoadClaims(
      LoadExpenseClaims event, Emitter<TravelState> emit) async {
    emit(TravelLoading());
    final result = await _repository.getClaims();
    result.fold(
      (f) => emit(TravelError(f)),
      (p) => emit(ExpenseClaimsLoaded(p.items, hasMore: p.hasMore, currentPage: p.currentPage)),
    );
  }

  Future<void> _onLoadMoreClaims(
      LoadMoreExpenseClaims event, Emitter<TravelState> emit) async {
    final current = state;
    if (current is! ExpenseClaimsLoaded || !current.hasMore) return;
    final result = await _repository.getClaims(page: current.currentPage + 1);
    result.fold(
      (f) => emit(TravelError(f)),
      (p) => emit(ExpenseClaimsLoaded(
        [...current.claims, ...p.items],
        hasMore: p.hasMore,
        currentPage: p.currentPage,
      )),
    );
  }

  Future<void> _onSubmitClaim(
      SubmitExpenseClaim event, Emitter<TravelState> emit) async {
    emit(TravelLoading());
    final result = await _repository.submitClaim(event.claimId);
    result.fold(
      (f) => emit(TravelError(f)),
      (_) => emit(ExpenseSubmitted()),
    );
  }

  Future<void> _onApproveExpense(
      ApproveExpense event, Emitter<TravelState> emit) async {
    final result = await _repository.approveExpense(event.id);
    result.fold(
      (f) => emit(TravelError(f)),
      (_) => emit(TravelActionSuccess()),
    );
  }

  Future<void> _onRejectExpense(
      RejectExpense event, Emitter<TravelState> emit) async {
    final result =
        await _repository.rejectExpense(event.id, event.comment);
    result.fold(
      (f) => emit(TravelError(f)),
      (_) => emit(TravelActionSuccess()),
    );
  }

  Future<void> _onLoadTravelDetail(
      LoadTravelRequestDetail event, Emitter<TravelState> emit) async {
    emit(TravelLoading());
    final result = await _repository.getTravelRequest(event.id);
    result.fold(
      (f) => emit(TravelError(f)),
      (r) => emit(TravelRequestDetailLoaded(r)),
    );
  }

  Future<void> _onLoadExpenseDetail(
      LoadExpenseClaimDetail event, Emitter<TravelState> emit) async {
    emit(TravelLoading());
    final result = await _repository.getClaim(event.claimId);
    result.fold(
      (f) => emit(TravelError(f)),
      (c) => emit(ExpenseClaimDetailLoaded(c)),
    );
  }
}
