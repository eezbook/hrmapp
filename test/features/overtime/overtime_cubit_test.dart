import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hrmapp/core/api/api_response.dart';
import 'package:hrmapp/features/overtime/data/datasources/overtime_remote_datasource.dart';
import 'package:hrmapp/features/overtime/data/models/overtime_model.dart';
import 'package:hrmapp/features/overtime/presentation/cubit/overtime_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockOvertimeRemoteDataSource extends Mock
    implements OvertimeRemoteDataSource {}

const _requestModel = OvertimeRequestModel(
  id: 1,
  date: '2025-06-10',
  startTime: '18:00',
  endTime: '20:00',
  hours: 2.0,
  amount: 60.0,
  status: 'pending',
  reason: 'Project deadline',
);

const _summary = OvertimeSummaryModel(
  totalApprovedHours: 8.0,
  totalAmount: 240.0,
  pendingCount: 1,
);

ApiResponse<List<OvertimeRequestModel>> _requestsOk(
        [List<OvertimeRequestModel> items = const [_requestModel]]) =>
    ApiResponse<List<OvertimeRequestModel>>(success: true, data: items);

ApiResponse<OvertimeSummaryModel> _summaryOk() =>
    const ApiResponse<OvertimeSummaryModel>(success: true, data: _summary);

ApiResponse<List<OvertimeRequestModel>> _approvalsOk() =>
    const ApiResponse<List<OvertimeRequestModel>>(
        success: true, data: [_requestModel]);

void main() {
  late OvertimeCubit cubit;
  late MockOvertimeRemoteDataSource remote;

  setUp(() {
    remote = MockOvertimeRemoteDataSource();
    cubit = OvertimeCubit(remote);
  });

  tearDown(() => cubit.close());

  group('loadRequests', () {
    blocTest<OvertimeCubit, OvertimeState>(
      'emits [OvertimeLoading, OvertimeLoaded] on success',
      build: () {
        when(() => remote.getRequests()).thenAnswer((_) async => _requestsOk());
        when(() => remote.getSummary()).thenAnswer((_) async => _summaryOk());
        return cubit;
      },
      act: (c) => c.loadRequests(),
      expect: () => [
        isA<OvertimeLoading>(),
        isA<OvertimeLoaded>()
            .having((s) => s.requests.length, 'count', 1)
            .having((s) => s.summary?.pendingCount, 'pending', 1)
            .having((s) => s.statusFilter, 'filter', isNull),
      ],
    );

    blocTest<OvertimeCubit, OvertimeState>(
      'emits [OvertimeLoading, OvertimeLoaded] with status filter',
      build: () {
        when(() => remote.getRequests(status: 'pending'))
            .thenAnswer((_) async => _requestsOk());
        when(() => remote.getSummary()).thenAnswer((_) async => _summaryOk());
        return cubit;
      },
      act: (c) => c.loadRequests(status: 'pending'),
      expect: () => [
        isA<OvertimeLoading>(),
        isA<OvertimeLoaded>()
            .having((s) => s.statusFilter, 'filter', 'pending'),
      ],
    );

    blocTest<OvertimeCubit, OvertimeState>(
      'emits [OvertimeLoading, OvertimeError] when remote throws',
      build: () {
        when(() => remote.getRequests()).thenThrow(Exception('timeout'));
        when(() => remote.getSummary()).thenThrow(Exception('timeout'));
        return cubit;
      },
      act: (c) => c.loadRequests(),
      expect: () => [isA<OvertimeLoading>(), isA<OvertimeError>()],
    );
  });

  group('applyOvertime', () {
    blocTest<OvertimeCubit, OvertimeState>(
      'emits [OvertimeLoading, AppliedSuccess] on success',
      build: () {
        when(() => remote.createRequest(any())).thenAnswer(
          (_) async => const ApiResponse<OvertimeRequestModel>(
            success: true,
            data: _requestModel,
          ),
        );
        return cubit;
      },
      act: (c) => c.applyOvertime({
        'date': '2025-06-10',
        'start_time': '18:00',
        'end_time': '20:00',
        'reason': 'Project deadline',
      }),
      expect: () => [isA<OvertimeLoading>(), isA<AppliedSuccess>()],
    );

    blocTest<OvertimeCubit, OvertimeState>(
      'emits [OvertimeLoading, OvertimeError] when remote throws',
      build: () {
        when(() => remote.createRequest(any()))
            .thenThrow(Exception('server error'));
        return cubit;
      },
      act: (c) => c.applyOvertime({}),
      expect: () => [isA<OvertimeLoading>(), isA<OvertimeError>()],
    );
  });

  group('cancelRequest', () {
    blocTest<OvertimeCubit, OvertimeState>(
      'emits [OvertimeActionSuccess] on success',
      build: () {
        when(() => remote.cancelRequest(1)).thenAnswer(
          (_) async => const ApiResponse<void>(success: true),
        );
        return cubit;
      },
      act: (c) => c.cancelRequest(1),
      expect: () => [isA<OvertimeActionSuccess>()],
    );

    blocTest<OvertimeCubit, OvertimeState>(
      'emits [OvertimeError] when remote throws',
      build: () {
        when(() => remote.cancelRequest(1))
            .thenThrow(Exception('not found'));
        return cubit;
      },
      act: (c) => c.cancelRequest(1),
      expect: () => [isA<OvertimeError>()],
    );
  });

  group('loadApprovals', () {
    blocTest<OvertimeCubit, OvertimeState>(
      'emits [OvertimeLoading, ApprovalsLoaded] on success',
      build: () {
        when(() => remote.getApprovals())
            .thenAnswer((_) async => _approvalsOk());
        return cubit;
      },
      act: (c) => c.loadApprovals(),
      expect: () => [
        isA<OvertimeLoading>(),
        isA<ApprovalsLoaded>()
            .having((s) => s.approvals.length, 'count', 1),
      ],
    );

    blocTest<OvertimeCubit, OvertimeState>(
      'emits [OvertimeLoading, OvertimeError] when remote throws',
      build: () {
        when(() => remote.getApprovals()).thenThrow(Exception('error'));
        return cubit;
      },
      act: (c) => c.loadApprovals(),
      expect: () => [isA<OvertimeLoading>(), isA<OvertimeError>()],
    );
  });

  group('approveRequest', () {
    blocTest<OvertimeCubit, OvertimeState>(
      'emits [OvertimeActionSuccess] on success',
      build: () {
        when(() => remote.approveRequest(1)).thenAnswer(
          (_) async => const ApiResponse<void>(success: true),
        );
        return cubit;
      },
      act: (c) => c.approveRequest(1),
      expect: () => [isA<OvertimeActionSuccess>()],
    );

    blocTest<OvertimeCubit, OvertimeState>(
      'emits [OvertimeError] on failure',
      build: () {
        when(() => remote.approveRequest(1)).thenThrow(Exception('denied'));
        return cubit;
      },
      act: (c) => c.approveRequest(1),
      expect: () => [isA<OvertimeError>()],
    );
  });

  group('rejectRequest', () {
    blocTest<OvertimeCubit, OvertimeState>(
      'emits [OvertimeActionSuccess] on success',
      build: () {
        when(() => remote.rejectRequest(1, any())).thenAnswer(
          (_) async => const ApiResponse<void>(success: true),
        );
        return cubit;
      },
      act: (c) => c.rejectRequest(1, 'Insufficient justification'),
      expect: () => [isA<OvertimeActionSuccess>()],
    );
  });
}
