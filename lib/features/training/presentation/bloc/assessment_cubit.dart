import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/error_handler.dart';
import '../../data/datasources/training_remote_datasource.dart';
import '../../data/models/course_model.dart';

abstract class AssessmentState extends Equatable {
  const AssessmentState();
  @override
  List<Object?> get props => [];
}

class AssessmentLoading extends AssessmentState {}

class AssessmentReady extends AssessmentState {
  final List<AssessmentQuestionModel> questions;
  final Map<int, int> answers;
  final int currentIndex;
  const AssessmentReady(this.questions,
      {this.answers = const {}, this.currentIndex = 0});
  @override
  List<Object?> get props => [questions, answers, currentIndex];
}

class Submitting extends AssessmentState {}

class PassResult extends AssessmentState {
  final double score;
  final CertificateModel? certificate;
  const PassResult(this.score, this.certificate);
  @override
  List<Object?> get props => [score];
}

class FailResult extends AssessmentState {
  final double score;
  final int attemptsRemaining;
  const FailResult(this.score, this.attemptsRemaining);
  @override
  List<Object?> get props => [score, attemptsRemaining];
}

class AssessmentError extends AssessmentState {
  final String message;
  const AssessmentError(this.message);
}

class AssessmentCubit extends Cubit<AssessmentState> {
  final TrainingRemoteDataSource _remote;
  final int courseId;

  AssessmentCubit(this._remote, this.courseId)
      : super(AssessmentLoading());

  Future<void> loadAssessment() async {
    emit(AssessmentLoading());
    try {
      final res = await _remote.getAssessment(courseId);
      emit(AssessmentReady(res.data ?? []));
    } catch (e) {
      emit(AssessmentError(ErrorHandler.handle(e).message));
    }
  }

  void selectAnswer(int questionId, int optionIndex) {
    final current = state;
    if (current is! AssessmentReady) return;
    final newAnswers = Map<int, int>.from(current.answers)
      ..[questionId] = optionIndex;
    emit(AssessmentReady(
      current.questions,
      answers: newAnswers,
      currentIndex: current.currentIndex,
    ));
  }

  void nextQuestion() {
    final current = state;
    if (current is! AssessmentReady) return;
    if (current.currentIndex < current.questions.length - 1) {
      emit(AssessmentReady(
        current.questions,
        answers: current.answers,
        currentIndex: current.currentIndex + 1,
      ));
    }
  }

  Future<void> submit() async {
    final current = state;
    if (current is! AssessmentReady) return;
    emit(Submitting());
    try {
      final res = await _remote.submitAssessment(courseId, {
        'answers': current.answers.map((k, v) => MapEntry(k.toString(), v)),
      });
      final data = res.data!;
      final score = (data['score'] as num).toDouble();
      final passed = data['passed'] as bool? ?? false;
      final attemptsRemaining = data['attempts_remaining'] as int? ?? 0;

      CertificateModel? cert;
      if (data['certificate'] != null) {
        cert = CertificateModel.fromJson(
            data['certificate'] as Map<String, dynamic>);
      }

      if (passed) {
        emit(PassResult(score, cert));
      } else {
        emit(FailResult(score, attemptsRemaining));
      }
    } catch (e) {
      emit(AssessmentError(ErrorHandler.handle(e).message));
    }
  }
}
