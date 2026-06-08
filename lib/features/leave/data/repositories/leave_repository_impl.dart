import 'package:dartz/dartz.dart';
import '../../../../core/api/api_response.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/leave_balance.dart';
import '../../domain/entities/leave_request.dart';
import '../../domain/repositories/leave_repository.dart';
import '../datasources/leave_remote_datasource.dart';
import '../models/leave_request_model.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final LeaveRemoteDataSource _remote;

  LeaveRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<LeaveBalance>>> getBalance() async {
    try {
      final res = await _remote.getBalance();
      return Right(res.data!.map(_mapBalance).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, PaginatedResponse<LeaveRequest>>> getRequests({
    String? status,
    int page = 1,
  }) async {
    try {
      final res = await _remote.getRequests(status: status, page: page);
      return Right(PaginatedResponse(
        items: res.data!.map(_mapRequest).toList(),
        currentPage: res.meta?.currentPage ?? 1,
        lastPage: res.meta?.lastPage ?? 1,
        total: res.meta?.total ?? 0,
      ));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, LeaveRequest>> getRequest(int id) async {
    try {
      final res = await _remote.getRequest(id);
      return Right(_mapRequest(res.data!));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, LeaveRequest>> applyLeave(
      Map<String, dynamic> params) async {
    try {
      final res = await _remote.applyLeave(params);
      return Right(_mapRequest(res.data!));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> cancelRequest(int id) async {
    try {
      await _remote.cancelRequest(id);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, PaginatedResponse<LeaveRequest>>> getApprovals({
    String? status,
    int page = 1,
  }) async {
    try {
      final res = await _remote.getApprovals(status: status, page: page);
      return Right(PaginatedResponse(
        items: res.data!.map(_mapRequest).toList(),
        currentPage: res.meta?.currentPage ?? 1,
        lastPage: res.meta?.lastPage ?? 1,
        total: res.meta?.total ?? 0,
      ));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> approveRequest(int id) async {
    try {
      await _remote.approveRequest(id);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> rejectRequest(int id, String comment) async {
    try {
      await _remote.rejectRequest(id, {'reason': comment});
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getPublicHolidays() async {
    try {
      final res = await _remote.getPublicHolidays();
      return Right(res.data ?? []);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, List<String>>>> getTeamCalendar(
      int month, int year) async {
    try {
      final res = await _remote.getTeamCalendar(month: month, year: year);
      return Right(res.data ?? {});
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  LeaveBalance _mapBalance(b) => LeaveBalance(
        id: b.id,
        leaveTypeName: b.leaveTypeName,
        leaveTypeCode: b.leaveTypeCode,
        allocated: b.allocated,
        used: b.used,
        pending: b.pending,
        remaining: b.remaining,
        color: b.color,
      );

  LeaveRequest _mapRequest(LeaveRequestModel m) => LeaveRequest(
        id: m.id,
        leaveTypeName: m.leaveTypeName,
        startDate: m.startDate,
        endDate: m.endDate,
        days: m.days,
        status: m.status,
        reason: m.reason,
        documentUrl: m.documentUrl,
        createdAt: m.createdAt,
        isHalfDay: m.isHalfDay ?? false,
        halfDaySession: m.halfDaySession,
        approvalTrail: m.approvalTrail
                ?.map((s) => ApprovalStep(
                      level: s.level,
                      approverName: s.approverName,
                      status: s.status,
                      comment: s.comment,
                      decidedAt: s.decidedAt,
                    ))
                .toList() ??
            [],
        employeeName: m.employeeName,
        employeePhoto: m.employeePhoto,
        leaveTypeCode: m.leaveTypeCode,
      );
}
