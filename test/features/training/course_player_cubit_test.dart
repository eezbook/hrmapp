import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hrmapp/core/api/api_response.dart';
import 'package:hrmapp/core/storage/hive_storage.dart';
import 'package:hrmapp/features/training/data/datasources/training_remote_datasource.dart';
import 'package:hrmapp/features/training/data/models/course_model.dart';
import 'package:hrmapp/features/training/presentation/bloc/course_player_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockTrainingRemoteDataSource extends Mock
    implements TrainingRemoteDataSource {}

const _course = CourseModel(
  id: 5,
  title: 'Safety Compliance',
  category: 'Compliance',
  type: 'video',
  durationMinutes: 45,
  isMandatory: true,
  contentUrl: 'https://cdn.example.com/video.mp4',
);

const _cert = CertificateModel(
  id: 10,
  courseId: 5,
  courseName: 'Safety Compliance',
  issuedDate: '2025-06-15',
);

void main() {
  late MockTrainingRemoteDataSource remote;
  late Directory tmpDir;

  setUpAll(() async {
    tmpDir = await Directory.systemTemp.createTemp('hive_course_player_');
    Hive.init(tmpDir.path);
    await HiveStorage.openBoxes();
  });

  tearDownAll(() async {
    await Hive.close();
    await tmpDir.delete(recursive: true);
  });

  setUp(() {
    remote = MockTrainingRemoteDataSource();
  });

  CoursePlayerCubit buildCubit() => CoursePlayerCubit(remote, 5);

  group('loadCourse', () {
    blocTest<CoursePlayerCubit, CoursePlayerState>(
      'emits [PlayerLoading, PlayerReady] on success with no saved position',
      build: () {
        when(() => remote.getCourse(5))
            .thenAnswer((_) async => ApiResponse<CourseModel>(
                  success: true,
                  data: _course,
                ));
        return buildCubit();
      },
      act: (c) => c.loadCourse(),
      expect: () => [
        isA<PlayerLoading>(),
        isA<PlayerReady>()
            .having((s) => s.course.id, 'id', 5)
            .having((s) => s.lastPositionSeconds, 'position', 0),
      ],
    );

    blocTest<CoursePlayerCubit, CoursePlayerState>(
      'emits [PlayerReady] with saved position when Hive has entry',
      build: () {
        HiveStorage.training.put('${HiveKeys.videoPosition}5', 120);
        when(() => remote.getCourse(5))
            .thenAnswer((_) async => ApiResponse<CourseModel>(
                  success: true,
                  data: _course,
                ));
        return buildCubit();
      },
      act: (c) => c.loadCourse(),
      expect: () => [
        isA<PlayerLoading>(),
        isA<PlayerReady>().having(
          (s) => s.lastPositionSeconds,
          'savedPosition',
          120,
        ),
      ],
      tearDown: () => HiveStorage.training.delete('${HiveKeys.videoPosition}5'),
    );

    blocTest<CoursePlayerCubit, CoursePlayerState>(
      'emits [PlayerLoading, PlayerError] when remote throws',
      build: () {
        when(() => remote.getCourse(5)).thenThrow(Exception('server error'));
        return buildCubit();
      },
      act: (c) => c.loadCourse(),
      expect: () => [isA<PlayerLoading>(), isA<PlayerError>()],
    );
  });

  group('savePosition', () {
    test('persists position to Hive', () {
      final cubit = buildCubit();
      cubit.savePosition(300);
      expect(
        HiveStorage.training.get('${HiveKeys.videoPosition}5'),
        300,
      );
      HiveStorage.training.delete('${HiveKeys.videoPosition}5');
      cubit.close();
    });
  });

  group('updateProgress', () {
    blocTest<CoursePlayerCubit, CoursePlayerState>(
      'emits [ProgressUpdated] at 25% milestone',
      build: () {
        when(() => remote.updateProgress(5, any()))
            .thenAnswer((_) async =>
                const ApiResponse<void>(success: true));
        return buildCubit();
      },
      act: (c) => c.updateProgress(0.25),
      expect: () => [isA<ProgressUpdated>()],
    );

    blocTest<CoursePlayerCubit, CoursePlayerState>(
      'emits [ProgressUpdated, CompletionReady] at 95%+',
      build: () {
        when(() => remote.updateProgress(5, any()))
            .thenAnswer((_) async =>
                const ApiResponse<void>(success: true));
        return buildCubit();
      },
      act: (c) => c.updateProgress(0.97),
      expect: () => [isA<ProgressUpdated>(), isA<CompletionReady>()],
    );

    blocTest<CoursePlayerCubit, CoursePlayerState>(
      'does not emit when milestone not yet reached',
      build: () => buildCubit(),
      act: (c) => c.updateProgress(0.10),
      expect: () => [],
    );

    blocTest<CoursePlayerCubit, CoursePlayerState>(
      'does not re-emit same milestone twice',
      build: () {
        when(() => remote.updateProgress(5, any()))
            .thenAnswer((_) async =>
                const ApiResponse<void>(success: true));
        return buildCubit();
      },
      act: (c) async {
        await c.updateProgress(0.25);
        await c.updateProgress(0.24);
      },
      expect: () => [isA<ProgressUpdated>()],
    );
  });

  group('completeCourse', () {
    blocTest<CoursePlayerCubit, CoursePlayerState>(
      'emits [CompletedSuccess] with certificate',
      build: () {
        HiveStorage.training.put('${HiveKeys.videoPosition}5', 2700);
        when(() => remote.completeCourse(5))
            .thenAnswer((_) async => const ApiResponse<CertificateModel?>(
                  success: true,
                  data: _cert,
                ));
        return buildCubit();
      },
      act: (c) => c.completeCourse(),
      expect: () => [
        isA<CompletedSuccess>().having(
          (s) => s.certificate?.id,
          'certId',
          10,
        ),
      ],
      verify: (_) {
        expect(
          HiveStorage.training.get('${HiveKeys.videoPosition}5'),
          isNull,
        );
      },
    );

    blocTest<CoursePlayerCubit, CoursePlayerState>(
      'emits [CompletedSuccess] with null certificate for courses without cert',
      build: () {
        when(() => remote.completeCourse(5))
            .thenAnswer((_) async => const ApiResponse<CertificateModel?>(
                  success: true,
                  data: null,
                ));
        return buildCubit();
      },
      act: (c) => c.completeCourse(),
      expect: () => [
        isA<CompletedSuccess>()
            .having((s) => s.certificate, 'cert', isNull),
      ],
    );

    blocTest<CoursePlayerCubit, CoursePlayerState>(
      'emits [PlayerError] when complete throws',
      build: () {
        when(() => remote.completeCourse(5))
            .thenThrow(Exception('network error'));
        return buildCubit();
      },
      act: (c) => c.completeCourse(),
      expect: () => [isA<PlayerError>()],
    );
  });
}
