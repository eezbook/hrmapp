import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hrmapp/core/api/api_response.dart';
import 'package:hrmapp/features/training/data/datasources/training_remote_datasource.dart';
import 'package:hrmapp/features/training/data/models/course_model.dart';
import 'package:hrmapp/features/training/presentation/bloc/training_bloc.dart';
import 'package:hrmapp/features/training/presentation/bloc/training_event.dart';
import 'package:hrmapp/features/training/presentation/bloc/training_state.dart';
import 'package:mocktail/mocktail.dart';

class MockTrainingRemoteDataSource extends Mock
    implements TrainingRemoteDataSource {}

const _course = CourseModel(
  id: 1,
  title: 'Flutter Fundamentals',
  category: 'Mobile',
  type: 'video',
  durationMinutes: 120,
  isMandatory: false,
);

const _certificate = CertificateModel(
  id: 1,
  courseId: 1,
  courseName: 'Flutter Fundamentals',
  issuedDate: '2025-06-01',
);

ApiResponse<T> _ok<T>(T data) => ApiResponse<T>(success: true, data: data);
ApiResponse<T> _err<T>() =>
    ApiResponse<T>(success: false, message: 'Internal Server Error');

void main() {
  late TrainingBloc bloc;
  late MockTrainingRemoteDataSource remote;

  setUp(() {
    remote = MockTrainingRemoteDataSource();
    bloc = TrainingBloc(remote);
  });

  tearDown(() => bloc.close());

  group('LoadCourses', () {
    blocTest<TrainingBloc, TrainingState>(
      'emits [TrainingLoading, CoursesLoaded] on success',
      build: () {
        when(() => remote.getCourses())
            .thenAnswer((_) async => _ok([_course]));
        when(() => remote.getCategories())
            .thenAnswer((_) async => _ok(['Mobile', 'Web']));
        return bloc;
      },
      act: (b) => b.add(const LoadCourses()),
      expect: () => [
        isA<TrainingLoading>(),
        isA<CoursesLoaded>()
            .having((s) => s.courses.length, 'courses', 1)
            .having((s) => s.categories.length, 'categories', 2),
      ],
    );

    blocTest<TrainingBloc, TrainingState>(
      'emits [TrainingLoading, CoursesLoaded] with category filter',
      build: () {
        when(() => remote.getCourses(category: 'Mobile'))
            .thenAnswer((_) async => _ok([_course]));
        when(() => remote.getCategories())
            .thenAnswer((_) async => _ok(['Mobile']));
        return bloc;
      },
      act: (b) => b.add(const LoadCourses(category: 'Mobile')),
      expect: () => [isA<TrainingLoading>(), isA<CoursesLoaded>()],
    );

    blocTest<TrainingBloc, TrainingState>(
      'emits [TrainingLoading, TrainingError] when remote throws',
      build: () {
        when(() => remote.getCourses()).thenThrow(Exception('timeout'));
        when(() => remote.getCategories())
            .thenAnswer((_) async => _ok([]));
        return bloc;
      },
      act: (b) => b.add(const LoadCourses()),
      expect: () => [isA<TrainingLoading>(), isA<TrainingError>()],
    );
  });

  group('LoadCourse', () {
    blocTest<TrainingBloc, TrainingState>(
      'emits [TrainingLoading, CourseDetailLoaded] on success',
      build: () {
        when(() => remote.getCourse(1))
            .thenAnswer((_) async => _ok(_course));
        return bloc;
      },
      act: (b) => b.add(const LoadCourse(1)),
      expect: () => [
        isA<TrainingLoading>(),
        isA<CourseDetailLoaded>()
            .having((s) => s.course.id, 'id', 1),
      ],
    );

    blocTest<TrainingBloc, TrainingState>(
      'emits [TrainingLoading, TrainingError] when course not found',
      build: () {
        when(() => remote.getCourse(999)).thenThrow(Exception('Not found'));
        return bloc;
      },
      act: (b) => b.add(const LoadCourse(999)),
      expect: () => [isA<TrainingLoading>(), isA<TrainingError>()],
    );
  });

  group('EnrollCourse', () {
    blocTest<TrainingBloc, TrainingState>(
      'emits [EnrolledSuccess] on success',
      build: () {
        when(() => remote.enrollCourse(1))
            .thenAnswer((_) async => const ApiResponse<void>(success: true));
        return bloc;
      },
      act: (b) => b.add(const EnrollCourse(1)),
      expect: () => [isA<EnrolledSuccess>()],
    );

    blocTest<TrainingBloc, TrainingState>(
      'emits [TrainingError] when enroll throws',
      build: () {
        when(() => remote.enrollCourse(1)).thenThrow(Exception('Not enrolled'));
        return bloc;
      },
      act: (b) => b.add(const EnrollCourse(1)),
      expect: () => [isA<TrainingError>()],
    );
  });

  group('LoadMyLearning', () {
    blocTest<TrainingBloc, TrainingState>(
      'emits [TrainingLoading, MyLearningLoaded] on success',
      build: () {
        when(() => remote.getMyLearning()).thenAnswer(
          (_) async => _ok({'in_progress': [_course], 'completed': []}),
        );
        return bloc;
      },
      act: (b) => b.add(LoadMyLearning()),
      expect: () => [
        isA<TrainingLoading>(),
        isA<MyLearningLoaded>()
            .having((s) => s.inProgress.length, 'in_progress', 1)
            .having((s) => s.completed.length, 'completed', 0),
      ],
    );

    blocTest<TrainingBloc, TrainingState>(
      'emits [TrainingLoading, TrainingError] on failure',
      build: () {
        when(() => remote.getMyLearning()).thenThrow(Exception('error'));
        return bloc;
      },
      act: (b) => b.add(LoadMyLearning()),
      expect: () => [isA<TrainingLoading>(), isA<TrainingError>()],
    );
  });

  group('LoadCertificates', () {
    blocTest<TrainingBloc, TrainingState>(
      'emits [TrainingLoading, CertificatesLoaded] on success',
      build: () {
        when(() => remote.getCertificates())
            .thenAnswer((_) async => _ok([_certificate]));
        return bloc;
      },
      act: (b) => b.add(LoadCertificates()),
      expect: () => [
        isA<TrainingLoading>(),
        isA<CertificatesLoaded>()
            .having((s) => s.certificates.length, 'count', 1),
      ],
    );

    blocTest<TrainingBloc, TrainingState>(
      'emits [TrainingLoading, CertificatesLoaded] with empty list',
      build: () {
        when(() => remote.getCertificates())
            .thenAnswer((_) async => _ok(<CertificateModel>[]));
        return bloc;
      },
      act: (b) => b.add(LoadCertificates()),
      expect: () => [
        isA<TrainingLoading>(),
        isA<CertificatesLoaded>().having((s) => s.certificates, 'empty', []),
      ],
    );
  });
}
