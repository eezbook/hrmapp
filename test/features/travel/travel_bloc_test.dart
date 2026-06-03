import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hrmapp/core/api/api_response.dart';
import 'package:hrmapp/core/error/failures.dart';
import 'package:hrmapp/features/travel/data/repositories/travel_repository_impl.dart';
import 'package:hrmapp/features/travel/domain/entities/expense_claim.dart';
import 'package:hrmapp/features/travel/domain/entities/travel_request.dart';
import 'package:hrmapp/features/travel/presentation/bloc/travel_bloc.dart';
import 'package:hrmapp/features/travel/presentation/bloc/travel_event.dart';
import 'package:hrmapp/features/travel/presentation/bloc/travel_state.dart';
import 'package:mocktail/mocktail.dart';

class MockTravelRepository extends Mock implements TravelRepository {}

const _travelRequest = TravelRequest(
  id: 1,
  purpose: 'Client visit',
  origin: 'Kuala Lumpur',
  destination: 'Penang',
  departureDate: '2025-06-10',
  returnDate: '2025-06-12',
  transportMode: 'flight',
  estimatedBudget: 800.0,
  status: 'pending',
);

const _expenseClaim = ExpenseClaim(
  id: 1,
  title: 'June trip expenses',
  total: 750.0,
  status: 'draft',
  items: [],
  createdAt: '2025-06-12',
);

PaginatedResponse<TravelRequest> _travelPage({bool hasMore = false}) =>
    PaginatedResponse(
      items: [_travelRequest],
      currentPage: 1,
      lastPage: hasMore ? 2 : 1,
      total: hasMore ? 20 : 1,
    );

PaginatedResponse<ExpenseClaim> _claimPage({bool hasMore = false, int page = 1}) =>
    PaginatedResponse(
      items: [_expenseClaim],
      currentPage: page,
      lastPage: hasMore ? page + 1 : page,
      total: hasMore ? 20 : 1,
    );

void main() {
  late TravelBloc bloc;
  late MockTravelRepository repository;

  setUp(() {
    repository = MockTravelRepository();
    bloc = TravelBloc(repository);
  });

  tearDown(() => bloc.close());

  group('LoadTravelRequests', () {
    blocTest<TravelBloc, TravelState>(
      'emits [TravelLoading, TravelRequestsLoaded] on success',
      build: () {
        when(() => repository.getTravelRequests())
            .thenAnswer((_) async => Right(_travelPage()));
        return bloc;
      },
      act: (b) => b.add(const LoadTravelRequests()),
      expect: () => [
        isA<TravelLoading>(),
        isA<TravelRequestsLoaded>().having(
          (s) => s.requests.length,
          'count',
          1,
        ),
      ],
    );

    blocTest<TravelBloc, TravelState>(
      'emits [TravelLoading, TravelError] on failure',
      build: () {
        when(() => repository.getTravelRequests())
            .thenAnswer((_) async => const Left(NetworkFailure()));
        return bloc;
      },
      act: (b) => b.add(const LoadTravelRequests()),
      expect: () => [isA<TravelLoading>(), isA<TravelError>()],
    );
  });

  group('LoadMoreTravelRequests', () {
    blocTest<TravelBloc, TravelState>(
      'appends items when hasMore is true',
      build: () {
        when(() => repository.getTravelRequests(page: 2))
            .thenAnswer((_) async => Right(PaginatedResponse(
                  items: [
                    const TravelRequest(
                      id: 2,
                      purpose: 'Training',
                      origin: 'KL',
                      destination: 'JB',
                      departureDate: '2025-07-01',
                      returnDate: '2025-07-02',
                      transportMode: 'car',
                      estimatedBudget: 200.0,
                      status: 'approved',
                    )
                  ],
                  currentPage: 2,
                  lastPage: 2,
                  total: 2,
                )));
        return bloc;
      },
      seed: () => TravelRequestsLoaded(
        [_travelRequest],
        hasMore: true,
        currentPage: 1,
      ),
      act: (b) => b.add(const LoadMoreTravelRequests()),
      expect: () => [
        isA<TravelRequestsLoaded>().having(
          (s) => s.requests.length,
          'count',
          2,
        ),
      ],
    );

    blocTest<TravelBloc, TravelState>(
      'does nothing when hasMore is false',
      build: () => bloc,
      seed: () => TravelRequestsLoaded([_travelRequest], hasMore: false),
      act: (b) => b.add(const LoadMoreTravelRequests()),
      expect: () => [],
    );
  });

  group('CreateTravelRequest', () {
    blocTest<TravelBloc, TravelState>(
      'emits [TravelLoading, TravelRequestCreated] on success',
      build: () {
        when(() => repository.createTravelRequest(any()))
            .thenAnswer((_) async => const Right(_travelRequest));
        return bloc;
      },
      act: (b) => b.add(const CreateTravelRequest({'purpose': 'Client visit'})),
      expect: () => [
        isA<TravelLoading>(),
        isA<TravelRequestCreated>()
            .having((s) => s.request.id, 'id', 1),
      ],
    );

    blocTest<TravelBloc, TravelState>(
      'emits [TravelLoading, TravelError] on failure',
      build: () {
        when(() => repository.createTravelRequest(any()))
            .thenAnswer((_) async => const Left(ServerFailure()));
        return bloc;
      },
      act: (b) => b.add(const CreateTravelRequest({})),
      expect: () => [isA<TravelLoading>(), isA<TravelError>()],
    );
  });

  group('CancelTravelRequest', () {
    blocTest<TravelBloc, TravelState>(
      'emits [TravelActionSuccess] on success',
      build: () {
        when(() => repository.cancelTravelRequest(1))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (b) => b.add(const CancelTravelRequest(1)),
      expect: () => [isA<TravelActionSuccess>()],
    );
  });

  group('LoadTravelApprovals', () {
    blocTest<TravelBloc, TravelState>(
      'emits [TravelLoading, TravelApprovalsLoaded] on success',
      build: () {
        when(() => repository.getTravelApprovals())
            .thenAnswer((_) async => const Right([_travelRequest]));
        return bloc;
      },
      act: (b) => b.add(LoadTravelApprovals()),
      expect: () => [
        isA<TravelLoading>(),
        isA<TravelApprovalsLoaded>()
            .having((s) => s.approvals.length, 'count', 1),
      ],
    );
  });

  group('ApproveTravelRequest / RejectTravelRequest', () {
    blocTest<TravelBloc, TravelState>(
      'emits [TravelActionSuccess] on approve',
      build: () {
        when(() => repository.approveTravelRequest(1))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (b) => b.add(const ApproveTravelRequest(1)),
      expect: () => [isA<TravelActionSuccess>()],
    );

    blocTest<TravelBloc, TravelState>(
      'emits [TravelActionSuccess] on reject',
      build: () {
        when(() => repository.rejectTravelRequest(1, 'Over budget'))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (b) => b.add(const RejectTravelRequest(1, 'Over budget')),
      expect: () => [isA<TravelActionSuccess>()],
    );

    blocTest<TravelBloc, TravelState>(
      'emits [TravelError] when approve fails',
      build: () {
        when(() => repository.approveTravelRequest(1))
            .thenAnswer((_) async => const Left(ServerFailure()));
        return bloc;
      },
      act: (b) => b.add(const ApproveTravelRequest(1)),
      expect: () => [isA<TravelError>()],
    );
  });

  group('LoadExpenseClaims', () {
    blocTest<TravelBloc, TravelState>(
      'emits [TravelLoading, ExpenseClaimsLoaded] on success',
      build: () {
        when(() => repository.getClaims())
            .thenAnswer((_) async => Right(_claimPage()));
        return bloc;
      },
      act: (b) => b.add(LoadExpenseClaims()),
      expect: () => [
        isA<TravelLoading>(),
        isA<ExpenseClaimsLoaded>()
            .having((s) => s.claims.length, 'count', 1),
      ],
    );
  });

  group('LoadMoreExpenseClaims', () {
    blocTest<TravelBloc, TravelState>(
      'appends claims when hasMore is true',
      build: () {
        when(() => repository.getClaims(page: 2))
            .thenAnswer((_) async => Right(_claimPage(page: 2)));
        return bloc;
      },
      seed: () => ExpenseClaimsLoaded(
        [_expenseClaim],
        hasMore: true,
        currentPage: 1,
      ),
      act: (b) => b.add(LoadMoreExpenseClaims()),
      expect: () => [
        isA<ExpenseClaimsLoaded>().having(
          (s) => s.claims.length,
          'count',
          2,
        ),
      ],
    );

    blocTest<TravelBloc, TravelState>(
      'does nothing when hasMore is false',
      build: () => bloc,
      seed: () => ExpenseClaimsLoaded([_expenseClaim], hasMore: false),
      act: (b) => b.add(LoadMoreExpenseClaims()),
      expect: () => [],
    );
  });

  group('SubmitExpenseClaim', () {
    blocTest<TravelBloc, TravelState>(
      'emits [TravelLoading, ExpenseSubmitted] on success',
      build: () {
        when(() => repository.submitClaim(1))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (b) => b.add(const SubmitExpenseClaim(1)),
      expect: () => [isA<TravelLoading>(), isA<ExpenseSubmitted>()],
    );
  });

  group('ApproveExpense / RejectExpense', () {
    blocTest<TravelBloc, TravelState>(
      'emits [TravelActionSuccess] on expense approve',
      build: () {
        when(() => repository.approveExpense(1))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (b) => b.add(const ApproveExpense(1)),
      expect: () => [isA<TravelActionSuccess>()],
    );

    blocTest<TravelBloc, TravelState>(
      'emits [TravelActionSuccess] on expense reject',
      build: () {
        when(() => repository.rejectExpense(1, 'Missing receipts'))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (b) => b.add(const RejectExpense(1, 'Missing receipts')),
      expect: () => [isA<TravelActionSuccess>()],
    );
  });
}
