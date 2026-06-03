import 'package:dartz/dartz.dart';
import '../../../../core/api/api_response.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/expense_claim.dart';
import '../../domain/entities/travel_request.dart';
import '../datasources/travel_remote_datasource.dart';
import '../models/expense_claim_model.dart';
import '../models/travel_request_model.dart';

class TravelRepository {
  final TravelRemoteDataSource _remote;

  TravelRepository(this._remote);

  Future<Either<Failure, PaginatedResponse<TravelRequest>>> getTravelRequests({
    String? status,
    int page = 1,
  }) async {
    try {
      final res = await _remote.getTravelRequests(status: status, page: page);
      return Right(PaginatedResponse(
        items: res.data!.map(_mapTravel).toList(),
        currentPage: res.meta?.currentPage ?? 1,
        lastPage: res.meta?.lastPage ?? 1,
        total: res.meta?.total ?? 0,
      ));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<Failure, TravelRequest>> getTravelRequest(int id) async {
    try {
      final res = await _remote.getTravelRequest(id);
      return Right(_mapTravel(res.data!));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<Failure, TravelRequest>> createTravelRequest(
      Map<String, dynamic> params) async {
    try {
      final res = await _remote.createTravelRequest(params);
      return Right(_mapTravel(res.data!));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<Failure, void>> cancelTravelRequest(int id) async {
    try {
      await _remote.cancelTravelRequest(id);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<Failure, List<TravelRequest>>> getTravelApprovals() async {
    try {
      final res = await _remote.getTravelApprovals();
      return Right(res.data!.map(_mapTravel).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<Failure, void>> approveTravelRequest(int id) async {
    try {
      await _remote.approveTravelRequest(id);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<Failure, void>> rejectTravelRequest(
      int id, String comment) async {
    try {
      await _remote.rejectTravelRequest(id, {'comment': comment});
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<Failure, PaginatedResponse<ExpenseClaim>>> getClaims({
    int page = 1,
  }) async {
    try {
      final res = await _remote.getClaims(page: page);
      return Right(PaginatedResponse(
        items: res.data!.map(_mapClaim).toList(),
        currentPage: res.meta?.currentPage ?? 1,
        lastPage: res.meta?.lastPage ?? 1,
        total: res.meta?.total ?? 0,
      ));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<Failure, ExpenseClaim>> getClaim(int id) async {
    try {
      final res = await _remote.getClaim(id);
      return Right(_mapClaim(res.data!));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<Failure, void>> submitClaim(int id) async {
    try {
      await _remote.submitClaim(id);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<Failure, List<ExpenseClaim>>> getExpenseApprovals() async {
    try {
      final res = await _remote.getExpenseApprovals();
      return Right(res.data!.map(_mapClaim).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<Failure, void>> approveExpense(int id) async {
    try {
      await _remote.approveExpense(id);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<Failure, void>> rejectExpense(int id, String comment) async {
    try {
      await _remote.rejectExpense(id, {'comment': comment});
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  TravelRequest _mapTravel(TravelRequestModel m) => TravelRequest(
        id: m.id,
        purpose: m.purpose,
        origin: m.origin,
        destination: m.destination,
        departureDate: m.departureDate,
        returnDate: m.returnDate,
        transportMode: m.transportMode,
        estimatedBudget: m.estimatedBudget,
        status: m.status,
        createdAt: m.createdAt,
        employeeName: m.employeeName,
        employeePhoto: m.employeePhoto,
        budgetLimit: m.budgetLimit,
      );

  ExpenseClaim _mapClaim(ExpenseClaimModel m) => ExpenseClaim(
        id: m.id,
        title: m.title,
        total: m.total,
        status: m.status,
        items: m.items.map(_mapItem).toList(),
        travelRequestId: m.travelRequestId,
        travelRequestDestination: m.travelRequestDestination,
        createdAt: m.createdAt,
        budgetAmount: m.budgetAmount,
      );

  ExpenseItem _mapItem(ExpenseItemModel m) => ExpenseItem(
        id: m.id,
        category: m.category,
        description: m.description,
        amount: m.amount,
        date: m.date,
        receiptUrl: m.receiptUrl,
        requiresReceipt: m.requiresReceipt ?? false,
        isPerDiem: m.isPerDiem ?? false,
      );
}
