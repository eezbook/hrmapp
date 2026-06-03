import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hrmapp/core/api/api_response.dart';
import 'package:hrmapp/core/error/failures.dart';
import 'package:hrmapp/features/leave/domain/entities/leave_balance.dart';
import 'package:hrmapp/features/leave/domain/entities/leave_request.dart';
import 'package:hrmapp/features/leave/domain/repositories/leave_repository.dart';
import 'package:hrmapp/features/leave/presentation/bloc/leave_bloc.dart';
import 'package:hrmapp/features/leave/presentation/bloc/leave_event.dart';
import 'package:hrmapp/features/leave/presentation/bloc/leave_state.dart';
import 'package:mocktail/mocktail.dart';

class MockLeaveRepository extends Mock implements LeaveRepository {}

const _balance = LeaveBalance(
  id: 1,
  leaveTypeName: 'Annual Leave',
  leaveTypeCode: 'AL',
  allocated: 14,
  used: 3,
  pending: 1,
  remaining: 10,
);

const _request = LeaveRequest(
  id: 1,
  leaveTypeName: 'Annual Leave',
  startDate: '2025-06-01',
  endDate: '2025-06-03',
  days: 3,
  status: 'pending',
  reason: 'Vacation',
);

PaginatedResponse<LeaveRequest> _page({
  List<LeaveRequest>? items,
  bool hasMore = false,
  int page = 1,
}) =>
    PaginatedResponse(
      items: items ?? [_request],
      currentPage: page,
      lastPage: hasMore ? page + 1 : page,
      total: hasMore ? 20 : (items?.length ?? 1),
    );

void main() {
  late LeaveBloc bloc;
  late MockLeaveRepository repository;

  setUp(() {
    repository = MockLeaveRepository();
    bloc = LeaveBloc(repository);
  });

  tearDown(() => bloc.close());

  group('LoadBalance', () {
    blocTest<LeaveBloc, LeaveState>(
      'emits [LeaveLoading, BalanceLoaded] on success',
      build: () {
        when(() => repository.getBalance())
            .thenAnswer((_) async => const Right([_balance]));
        return bloc;
      },
      act: (b) => b.add(LoadBalance()),
      expect: () => [
        isA<LeaveLoading>(),
        isA<BalanceLoaded>().having(
          (s) => s.balances,
          'balances',
          [_balance],
        ),
      ],
    );

    blocTest<LeaveBloc, LeaveState>(
      'emits [LeaveLoading, LeaveError] on failure',
      build: () {
        when(() => repository.getBalance())
            .thenAnswer((_) async => const Left(NetworkFailure()));
        return bloc;
      },
      act: (b) => b.add(LoadBalance()),
      expect: () => [isA<LeaveLoading>(), isA<LeaveError>()],
    );
  });

  group('LoadRequests', () {
    blocTest<LeaveBloc, LeaveState>(
      'emits [LeaveLoading, RequestsLoaded] on success',
      build: () {
        when(() => repository.getRequests(page: 1))
            .thenAnswer((_) async => Right(_page()));
        return bloc;
      },
      act: (b) => b.add(const LoadRequests()),
      expect: () => [
        isA<LeaveLoading>(),
        isA<RequestsLoaded>().having((s) => s.requests.length, 'count', 1),
      ],
    );

    blocTest<LeaveBloc, LeaveState>(
      'emits [LeaveLoading, RequestsLoaded] with status filter',
      build: () {
        when(() => repository.getRequests(status: 'pending', page: 1))
            .thenAnswer((_) async => Right(_page()));
        return bloc;
      },
      act: (b) => b.add(const LoadRequests(status: 'pending')),
      expect: () => [isA<LeaveLoading>(), isA<RequestsLoaded>()],
    );

    blocTest<LeaveBloc, LeaveState>(
      'emits [LeaveLoading, LeaveError] on failure',
      build: () {
        when(() => repository.getRequests(page: 1))
            .thenAnswer((_) async => const Left(ServerFailure()));
        return bloc;
      },
      act: (b) => b.add(const LoadRequests()),
      expect: () => [isA<LeaveLoading>(), isA<LeaveError>()],
    );
  });

  group('LoadMoreRequests', () {
    blocTest<LeaveBloc, LeaveState>(
      'emits [LeaveLoadingMore, RequestsLoaded] appending items',
      build: () {
        when(() => repository.getRequests(page: 2))
            .thenAnswer((_) async => Right(_page(
                  items: [
                    const LeaveRequest(
                      id: 2,
                      leaveTypeName: 'Sick Leave',
                      startDate: '2025-07-01',
                      endDate: '2025-07-01',
                      days: 1,
                      status: 'approved',
                      reason: 'Ill',
                    )
                  ],
                  page: 2,
                )));
        return bloc;
      },
      seed: () => RequestsLoaded([_request], hasMore: true, currentPage: 1),
      act: (b) => b.add(const LoadMoreRequests()),
      expect: () => [
        isA<LeaveLoadingMore>(),
        isA<RequestsLoaded>().having((s) => s.requests.length, 'count', 2),
      ],
    );

    blocTest<LeaveBloc, LeaveState>(
      'does nothing when hasMore is false',
      build: () => bloc,
      seed: () => RequestsLoaded([_request], hasMore: false, currentPage: 1),
      act: (b) => b.add(const LoadMoreRequests()),
      expect: () => [],
    );

    blocTest<LeaveBloc, LeaveState>(
      'does nothing when state is not RequestsLoaded',
      build: () => bloc,
      act: (b) => b.add(const LoadMoreRequests()),
      expect: () => [],
    );
  });

  group('ApplyLeave', () {
    blocTest<LeaveBloc, LeaveState>(
      'emits [LeaveLoading, AppliedSuccess] on success',
      build: () {
        when(() => repository.applyLeave(any()))
            .thenAnswer((_) async => const Right(_request));
        return bloc;
      },
      act: (b) => b.add(const ApplyLeave({'leave_type_id': 1})),
      expect: () => [
        isA<LeaveLoading>(),
        isA<AppliedSuccess>().having((s) => s.request.id, 'id', 1),
      ],
    );

    blocTest<LeaveBloc, LeaveState>(
      'emits [LeaveLoading, LeaveError] on validation failure',
      build: () {
        when(() => repository.applyLeave(any())).thenAnswer(
          (_) async => const Left(ValidationFailure(errors: {})),
        );
        return bloc;
      },
      act: (b) => b.add(const ApplyLeave({})),
      expect: () => [isA<LeaveLoading>(), isA<LeaveError>()],
    );
  });

  group('CancelRequest', () {
    blocTest<LeaveBloc, LeaveState>(
      'emits [LeaveLoading, CancelledSuccess] on success',
      build: () {
        when(() => repository.cancelRequest(1))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (b) => b.add(const CancelRequest(1)),
      expect: () => [isA<LeaveLoading>(), isA<CancelledSuccess>()],
    );

    blocTest<LeaveBloc, LeaveState>(
      'emits [LeaveLoading, LeaveError] on failure',
      build: () {
        when(() => repository.cancelRequest(1))
            .thenAnswer((_) async => const Left(ServerFailure()));
        return bloc;
      },
      act: (b) => b.add(const CancelRequest(1)),
      expect: () => [isA<LeaveLoading>(), isA<LeaveError>()],
    );
  });

  group('LoadApprovals', () {
    blocTest<LeaveBloc, LeaveState>(
      'emits [LeaveLoading, ApprovalsLoaded] on success',
      build: () {
        when(() => repository.getApprovals(page: 1))
            .thenAnswer((_) async => Right(_page()));
        return bloc;
      },
      act: (b) => b.add(const LoadApprovals()),
      expect: () => [
        isA<LeaveLoading>(),
        isA<ApprovalsLoaded>().having(
          (s) => s.approvals.length,
          'count',
          1,
        ),
      ],
    );
  });

  group('ApproveLeave / RejectLeave', () {
    blocTest<LeaveBloc, LeaveState>(
      'emits [ApprovalActionSuccess] on approve',
      build: () {
        when(() => repository.approveRequest(1))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (b) => b.add(const ApproveLeave(1)),
      expect: () => [isA<ApprovalActionSuccess>()],
    );

    blocTest<LeaveBloc, LeaveState>(
      'emits [ApprovalActionSuccess] on reject',
      build: () {
        when(() => repository.rejectRequest(1, 'Insufficient balance'))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (b) => b.add(const RejectLeave(1, 'Insufficient balance')),
      expect: () => [isA<ApprovalActionSuccess>()],
    );

    blocTest<LeaveBloc, LeaveState>(
      'emits [LeaveError] when approve fails',
      build: () {
        when(() => repository.approveRequest(1))
            .thenAnswer((_) async => const Left(PermissionFailure(
                  hrmErrorCode: 'HRM_LEAVE_401',
                )));
        return bloc;
      },
      act: (b) => b.add(const ApproveLeave(1)),
      expect: () => [isA<LeaveError>()],
    );
  });
}
