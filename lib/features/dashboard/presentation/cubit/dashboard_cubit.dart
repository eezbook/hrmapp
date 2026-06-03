import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/error_handler.dart';
import '../../data/datasources/dashboard_remote_datasource.dart';
import '../../data/models/dashboard_data_model.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardDataModel data;
  const DashboardLoaded(this.data);
  @override
  List<Object?> get props => [data];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
  @override
  List<Object?> get props => [message];
}

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRemoteDataSource _remote;

  DashboardCubit(this._remote) : super(DashboardLoading());

  Future<void> loadDashboard() async {
    emit(DashboardLoading());
    try {
      final res = await _remote.getDashboard();
      emit(DashboardLoaded(res.data!));
    } catch (e) {
      emit(DashboardError(ErrorHandler.handle(e).message));
    }
  }
}
