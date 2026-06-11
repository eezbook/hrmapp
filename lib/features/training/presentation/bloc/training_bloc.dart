import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/error_handler.dart';
import '../../data/datasources/training_remote_datasource.dart';
import '../../data/models/course_model.dart';
import 'training_event.dart';
import 'training_state.dart';

class TrainingBloc extends Bloc<TrainingEvent, TrainingState> {
  final TrainingRemoteDataSource _remote;

  TrainingBloc(this._remote) : super(TrainingInitial()) {
    on<LoadCourses>(_onLoadCourses);
    on<LoadCourse>(_onLoadCourse);
    on<EnrollCourse>(_onEnroll);
    on<LoadMyLearning>(_onLoadMyLearning);
    on<LoadCertificates>(_onLoadCertificates);
    on<LoadTrainingRequests>(_onLoadTrainingRequests);
    on<SubmitTrainingRequest>(_onSubmitTrainingRequest);
  }

  Future<void> _onLoadCourses(
      LoadCourses event, Emitter<TrainingState> emit) async {
    emit(TrainingLoading());
    try {
      final coursesRes = await _remote.getCourses(
        category: event.category,
        search: event.search,
      );
      final categoriesRes = await _remote.getCategories();
      emit(CoursesLoaded(
        coursesRes.data ?? [],
        categoriesRes.data ?? [],
      ));
    } catch (e) {
      emit(TrainingError(ErrorHandler.handle(e)));
    }
  }

  Future<void> _onLoadCourse(
      LoadCourse event, Emitter<TrainingState> emit) async {
    emit(TrainingLoading());
    try {
      final res = await _remote.getCourse(event.id);
      emit(CourseDetailLoaded(res.data!));
    } catch (e) {
      emit(TrainingError(ErrorHandler.handle(e)));
    }
  }

  Future<void> _onEnroll(
      EnrollCourse event, Emitter<TrainingState> emit) async {
    try {
      await _remote.enrollCourse(event.id);
      emit(EnrolledSuccess());
    } catch (e) {
      emit(TrainingError(ErrorHandler.handle(e)));
    }
  }

  Future<void> _onLoadMyLearning(
      LoadMyLearning event, Emitter<TrainingState> emit) async {
    emit(TrainingLoading());
    try {
      final res = await _remote.getMyLearning();
      final data = (res.data as Map<String, dynamic>?) ?? {};

      List<CourseModel> _parseList(dynamic raw) {
        if (raw is! List) return [];
        return raw
            .whereType<Map<String, dynamic>>()
            .map(CourseModel.fromJson)
            .toList();
      }

      emit(MyLearningLoaded(
        enrolledCount: (data['enrolled'] as num?)?.toInt() ?? 0,
        completedCount: (data['completed'] as num?)?.toInt() ?? 0,
        inProgressCount: (data['inProgress'] as num?)?.toInt() ?? 0,
        totalHours: (data['totalHours'] as num?)?.toDouble() ?? 0.0,
        inProgressCourses: _parseList(data['inProgressCourses']),
        completedCourses: _parseList(data['completedCourses']),
      ));
    } catch (e) {
      emit(TrainingError(ErrorHandler.handle(e)));
    }
  }

  Future<void> _onLoadCertificates(
      LoadCertificates event, Emitter<TrainingState> emit) async {
    emit(TrainingLoading());
    try {
      final res = await _remote.getCertificates();
      emit(CertificatesLoaded(res.data ?? []));
    } catch (e) {
      emit(TrainingError(ErrorHandler.handle(e)));
    }
  }

  Future<void> _onLoadTrainingRequests(
      LoadTrainingRequests event, Emitter<TrainingState> emit) async {
    emit(TrainingLoading());
    try {
      final res = await _remote.getTrainingRequests(status: event.status);
      emit(TrainingRequestsLoaded(res.data ?? []));
    } catch (e) {
      emit(TrainingError(ErrorHandler.handle(e)));
    }
  }

  Future<void> _onSubmitTrainingRequest(
      SubmitTrainingRequest event, Emitter<TrainingState> emit) async {
    emit(TrainingLoading());
    try {
      await _remote.submitTrainingRequest(event.params);
      emit(TrainingRequestSubmitted());
    } catch (e) {
      emit(TrainingError(ErrorHandler.handle(e)));
    }
  }
}
