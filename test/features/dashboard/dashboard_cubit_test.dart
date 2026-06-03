import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hrmapp/core/api/api_response.dart';
import 'package:hrmapp/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:hrmapp/features/dashboard/data/models/dashboard_data_model.dart';
import 'package:hrmapp/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockDashboardRemoteDataSource extends Mock
    implements DashboardRemoteDataSource {}

const _dashboardData = DashboardDataModel(
  pendingLeaveCount: 1,
  pendingApprovalsCount: 3,
  mandatoryTrainingDue: 2,
  myLearningProgress: 65.0,
  pendingExpenseClaimsCount: 1,
  nearestTrainingDeadline: '2025-07-01',
  nearestTrainingTitle: 'Safety Compliance',
);

void main() {
  late DashboardCubit cubit;
  late MockDashboardRemoteDataSource remote;

  setUp(() {
    remote = MockDashboardRemoteDataSource();
    cubit = DashboardCubit(remote);
  });

  tearDown(() => cubit.close());

  group('loadDashboard', () {
    blocTest<DashboardCubit, DashboardState>(
      'emits [DashboardLoading, DashboardLoaded] on success',
      build: () {
        when(() => remote.getDashboard()).thenAnswer(
          (_) async => const ApiResponse<DashboardDataModel>(
            success: true,
            data: _dashboardData,
          ),
        );
        return cubit;
      },
      act: (c) => c.loadDashboard(),
      expect: () => [
        isA<DashboardLoading>(),
        isA<DashboardLoaded>()
            .having((s) => s.data.pendingLeaveCount, 'pendingLeave', 1)
            .having(
                (s) => s.data.pendingApprovalsCount, 'pendingApprovals', 3)
            .having(
                (s) => s.data.mandatoryTrainingDue, 'trainingDue', 2)
            .having(
                (s) => s.data.myLearningProgress, 'learningProgress', 65.0),
      ],
    );

    blocTest<DashboardCubit, DashboardState>(
      'emits [DashboardLoading, DashboardLoaded] with null optional fields',
      build: () {
        when(() => remote.getDashboard()).thenAnswer(
          (_) async => const ApiResponse<DashboardDataModel>(
            success: true,
            data: DashboardDataModel(),
          ),
        );
        return cubit;
      },
      act: (c) => c.loadDashboard(),
      expect: () => [
        isA<DashboardLoading>(),
        isA<DashboardLoaded>()
            .having((s) => s.data.pendingLeaveCount, 'nullableField', isNull),
      ],
    );

    blocTest<DashboardCubit, DashboardState>(
      'emits [DashboardLoading, DashboardError] when remote throws',
      build: () {
        when(() => remote.getDashboard())
            .thenThrow(Exception('network error'));
        return cubit;
      },
      act: (c) => c.loadDashboard(),
      expect: () => [isA<DashboardLoading>(), isA<DashboardError>()],
    );

    blocTest<DashboardCubit, DashboardState>(
      'initial state is DashboardLoading',
      build: () => cubit,
      verify: (c) => expect(c.state, isA<DashboardLoading>()),
    );

    blocTest<DashboardCubit, DashboardState>(
      're-emits [DashboardLoading, DashboardLoaded] on second load',
      build: () {
        when(() => remote.getDashboard()).thenAnswer(
          (_) async => const ApiResponse<DashboardDataModel>(
            success: true,
            data: _dashboardData,
          ),
        );
        return cubit;
      },
      act: (c) async {
        await c.loadDashboard();
        await c.loadDashboard();
      },
      expect: () => [
        isA<DashboardLoading>(),
        isA<DashboardLoaded>(),
        isA<DashboardLoading>(),
        isA<DashboardLoaded>(),
      ],
    );
  });
}
