import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hrmapp/core/api/api_response.dart';
import 'package:hrmapp/features/training/data/datasources/training_remote_datasource.dart';
import 'package:hrmapp/features/training/data/models/course_model.dart';
import 'package:hrmapp/features/training/presentation/bloc/assessment_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockTrainingRemoteDataSource extends Mock
    implements TrainingRemoteDataSource {}

const _q1 = AssessmentQuestionModel(
  id: 1,
  question: 'What is Flutter?',
  options: ['A framework', 'A database', 'A language', 'A server'],
);
const _q2 = AssessmentQuestionModel(
  id: 2,
  question: 'What is Dart?',
  options: ['A language', 'A framework', 'A library', 'A tool'],
);

const _cert = CertificateModel(
  id: 20,
  courseId: 3,
  courseName: 'Flutter Intro',
  issuedDate: '2025-06-20',
);

void main() {
  late MockTrainingRemoteDataSource remote;

  setUp(() {
    remote = MockTrainingRemoteDataSource();
  });

  AssessmentCubit buildCubit() => AssessmentCubit(remote, 3);

  group('loadAssessment', () {
    blocTest<AssessmentCubit, AssessmentState>(
      'emits [AssessmentLoading, AssessmentReady] with questions',
      build: () {
        when(() => remote.getAssessment(3)).thenAnswer(
          (_) async => ApiResponse<List<AssessmentQuestionModel>>(
            success: true,
            data: [_q1, _q2],
          ),
        );
        return buildCubit();
      },
      act: (c) => c.loadAssessment(),
      expect: () => [
        isA<AssessmentLoading>(),
        isA<AssessmentReady>()
            .having((s) => s.questions.length, 'questions', 2)
            .having((s) => s.currentIndex, 'index', 0)
            .having((s) => s.answers, 'answers', isEmpty),
      ],
    );

    blocTest<AssessmentCubit, AssessmentState>(
      'emits [AssessmentLoading, AssessmentReady] with empty list',
      build: () {
        when(() => remote.getAssessment(3)).thenAnswer(
          (_) async => const ApiResponse<List<AssessmentQuestionModel>>(
            success: true,
            data: [],
          ),
        );
        return buildCubit();
      },
      act: (c) => c.loadAssessment(),
      expect: () => [
        isA<AssessmentLoading>(),
        isA<AssessmentReady>().having((s) => s.questions, 'empty', []),
      ],
    );

    blocTest<AssessmentCubit, AssessmentState>(
      'emits [AssessmentLoading, AssessmentError] when remote throws',
      build: () {
        when(() => remote.getAssessment(3)).thenThrow(Exception('not found'));
        return buildCubit();
      },
      act: (c) => c.loadAssessment(),
      expect: () => [isA<AssessmentLoading>(), isA<AssessmentError>()],
    );
  });

  group('selectAnswer', () {
    blocTest<AssessmentCubit, AssessmentState>(
      'emits updated AssessmentReady with recorded answer',
      build: () => buildCubit(),
      seed: () => AssessmentReady([_q1, _q2], answers: {}, currentIndex: 0),
      act: (c) => c.selectAnswer(1, 0),
      expect: () => [
        isA<AssessmentReady>().having(
          (s) => s.answers[1],
          'answer for q1',
          0,
        ),
      ],
    );

    blocTest<AssessmentCubit, AssessmentState>(
      'replaces previous answer for same question',
      build: () => buildCubit(),
      seed: () => AssessmentReady([_q1], answers: {1: 2}, currentIndex: 0),
      act: (c) => c.selectAnswer(1, 1),
      expect: () => [
        isA<AssessmentReady>().having(
          (s) => s.answers[1],
          'updated answer',
          1,
        ),
      ],
    );

    blocTest<AssessmentCubit, AssessmentState>(
      'does nothing when not in AssessmentReady state',
      build: () => buildCubit(),
      act: (c) => c.selectAnswer(1, 0),
      expect: () => [],
    );
  });

  group('nextQuestion', () {
    blocTest<AssessmentCubit, AssessmentState>(
      'advances currentIndex by 1',
      build: () => buildCubit(),
      seed: () => AssessmentReady([_q1, _q2], currentIndex: 0),
      act: (c) => c.nextQuestion(),
      expect: () => [
        isA<AssessmentReady>()
            .having((s) => s.currentIndex, 'index', 1),
      ],
    );

    blocTest<AssessmentCubit, AssessmentState>(
      'does not advance past last question',
      build: () => buildCubit(),
      seed: () => AssessmentReady([_q1, _q2], currentIndex: 1),
      act: (c) => c.nextQuestion(),
      expect: () => [],
    );

    blocTest<AssessmentCubit, AssessmentState>(
      'does nothing when not in AssessmentReady state',
      build: () => buildCubit(),
      act: (c) => c.nextQuestion(),
      expect: () => [],
    );
  });

  group('submit', () {
    blocTest<AssessmentCubit, AssessmentState>(
      'emits [Submitting, PassResult] on pass',
      build: () {
        when(() => remote.submitAssessment(3, any())).thenAnswer(
          (_) async => ApiResponse<Map<String, dynamic>>(
            success: true,
            data: {
              'score': 90.0,
              'passed': true,
              'attempts_remaining': 0,
              'certificate': {
                'id': 20,
                'course_id': 3,
                'course_name': 'Flutter Intro',
                'issued_date': '2025-06-20',
              },
            },
          ),
        );
        return buildCubit();
      },
      seed: () => AssessmentReady([_q1, _q2], answers: {1: 0, 2: 0}),
      act: (c) => c.submit(),
      expect: () => [
        isA<Submitting>(),
        isA<PassResult>()
            .having((s) => s.score, 'score', 90.0)
            .having((s) => s.certificate?.id, 'certId', 20),
      ],
    );

    blocTest<AssessmentCubit, AssessmentState>(
      'emits [Submitting, PassResult] with null cert when not awarded',
      build: () {
        when(() => remote.submitAssessment(3, any())).thenAnswer(
          (_) async => ApiResponse<Map<String, dynamic>>(
            success: true,
            data: {
              'score': 80.0,
              'passed': true,
              'attempts_remaining': 0,
            },
          ),
        );
        return buildCubit();
      },
      seed: () => AssessmentReady([_q1], answers: {1: 0}),
      act: (c) => c.submit(),
      expect: () => [
        isA<Submitting>(),
        isA<PassResult>().having((s) => s.certificate, 'cert', isNull),
      ],
    );

    blocTest<AssessmentCubit, AssessmentState>(
      'emits [Submitting, FailResult] on fail',
      build: () {
        when(() => remote.submitAssessment(3, any())).thenAnswer(
          (_) async => ApiResponse<Map<String, dynamic>>(
            success: true,
            data: {
              'score': 45.0,
              'passed': false,
              'attempts_remaining': 2,
            },
          ),
        );
        return buildCubit();
      },
      seed: () => AssessmentReady([_q1, _q2], answers: {1: 3, 2: 3}),
      act: (c) => c.submit(),
      expect: () => [
        isA<Submitting>(),
        isA<FailResult>()
            .having((s) => s.score, 'score', 45.0)
            .having((s) => s.attemptsRemaining, 'attempts', 2),
      ],
    );

    blocTest<AssessmentCubit, AssessmentState>(
      'emits [Submitting, AssessmentError] when remote throws',
      build: () {
        when(() => remote.submitAssessment(3, any()))
            .thenThrow(Exception('network error'));
        return buildCubit();
      },
      seed: () => AssessmentReady([_q1], answers: {1: 0}),
      act: (c) => c.submit(),
      expect: () => [isA<Submitting>(), isA<AssessmentError>()],
    );

    blocTest<AssessmentCubit, AssessmentState>(
      'does nothing when not in AssessmentReady state',
      build: () => buildCubit(),
      act: (c) => c.submit(),
      expect: () => [],
    );
  });
}
