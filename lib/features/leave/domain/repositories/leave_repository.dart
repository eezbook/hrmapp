import 'package:dartz/dartz.dart';
import '../../../../core/api/api_response.dart';
import '../../../../core/error/failures.dart';
import '../entities/leave_balance.dart';
import '../entities/leave_request.dart';

abstract class LeaveRepository {
  Future<Either<Failure, List<LeaveBalance>>> getBalance();
  Future<Either<Failure, PaginatedResponse<LeaveRequest>>> getRequests({
    String? status,
    int page,
  });
  Future<Either<Failure, LeaveRequest>> getRequest(int id);
  Future<Either<Failure, LeaveRequest>> applyLeave(
      Map<String, dynamic> params);
  Future<Either<Failure, void>> cancelRequest(int id);
  Future<Either<Failure, PaginatedResponse<LeaveRequest>>> getApprovals({
    String? status,
    int page,
  });
  Future<Either<Failure, void>> approveRequest(int id);
  Future<Either<Failure, void>> rejectRequest(int id, String comment);
  Future<Either<Failure, List<String>>> getPublicHolidays();
  Future<Either<Failure, Map<String, List<String>>>> getTeamCalendar(
      int month, int year);
}
