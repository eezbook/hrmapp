import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/leave_balance.dart';
import '../../domain/repositories/leave_repository.dart';

abstract class LeaveBalanceState {
  const LeaveBalanceState();
}

class LeaveBalanceInitial extends LeaveBalanceState {
  const LeaveBalanceInitial();
}

class LeaveBalanceLoading extends LeaveBalanceState {
  const LeaveBalanceLoading();
}

class LeaveBalanceLoaded extends LeaveBalanceState {
  final List<LeaveBalance> balances;
  const LeaveBalanceLoaded(this.balances);
}

class LeaveBalanceError extends LeaveBalanceState {
  final String message;
  const LeaveBalanceError(this.message);
}

class LeaveBalanceCubit extends Cubit<LeaveBalanceState> {
  final LeaveRepository _repository;

  LeaveBalanceCubit(this._repository) : super(const LeaveBalanceInitial());

  Future<void> load() async {
    emit(const LeaveBalanceLoading());
    final result = await _repository.getBalance();
    result.fold(
      (f) => emit(LeaveBalanceError(f.message)),
      (balances) => emit(LeaveBalanceLoaded(balances)),
    );
  }
}
