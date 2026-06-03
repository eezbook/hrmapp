import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/storage/hive_storage.dart';
import '../../data/datasources/training_remote_datasource.dart';
import '../../data/models/course_model.dart';

abstract class CoursePlayerState extends Equatable {
  const CoursePlayerState();
  @override
  List<Object?> get props => [];
}

class PlayerLoading extends CoursePlayerState {}

class PlayerReady extends CoursePlayerState {
  final CourseModel course;
  final int lastPositionSeconds;
  const PlayerReady(this.course, {this.lastPositionSeconds = 0});
  @override
  List<Object?> get props => [course, lastPositionSeconds];
}

class ProgressUpdated extends CoursePlayerState {
  final double percent;
  const ProgressUpdated(this.percent);
  @override
  List<Object?> get props => [percent];
}

class CompletionReady extends CoursePlayerState {}

class CompletedSuccess extends CoursePlayerState {
  final CertificateModel? certificate;
  const CompletedSuccess(this.certificate);
}

class PlayerError extends CoursePlayerState {
  final String message;
  const PlayerError(this.message);
}

class CoursePlayerCubit extends Cubit<CoursePlayerState> {
  final TrainingRemoteDataSource _remote;
  final int courseId;
  double _lastReportedMilestone = 0;

  CoursePlayerCubit(this._remote, this.courseId) : super(PlayerLoading());

  Future<void> loadCourse() async {
    emit(PlayerLoading());
    try {
      final res = await _remote.getCourse(courseId);
      final course = res.data!;
      final savedPos = HiveStorage.training.get(
        '${HiveKeys.videoPosition}$courseId',
        defaultValue: 0,
      ) as int;
      emit(PlayerReady(course, lastPositionSeconds: savedPos));
    } catch (e) {
      emit(PlayerError(ErrorHandler.handle(e).message));
    }
  }

  void savePosition(int seconds) {
    HiveStorage.training.put('${HiveKeys.videoPosition}$courseId', seconds);
  }

  Future<void> updateProgress(double percent) async {
    final milestones = [0.25, 0.50, 0.75, 1.0];
    final milestone = milestones.lastWhere(
      (m) => percent >= m && m > _lastReportedMilestone,
      orElse: () => -1,
    );
    if (milestone == -1) return;
    _lastReportedMilestone = milestone;

    try {
      await _remote.updateProgress(courseId, {'progress': percent * 100});
      emit(ProgressUpdated(percent));
      if (percent >= 0.95) emit(CompletionReady());
    } catch (_) {}
  }

  Future<void> completeCourse() async {
    try {
      final res = await _remote.completeCourse(courseId);
      HiveStorage.training.delete('${HiveKeys.videoPosition}$courseId');
      emit(CompletedSuccess(res.data));
    } catch (e) {
      emit(PlayerError(ErrorHandler.handle(e).message));
    }
  }
}
