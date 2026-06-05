import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/course_model.dart';

abstract class TrainingState extends Equatable {
  const TrainingState();
  @override
  List<Object?> get props => [];
}

class TrainingInitial extends TrainingState {}
class TrainingLoading extends TrainingState {}

class CoursesLoaded extends TrainingState {
  final List<CourseModel> courses;
  final List<String> categories;
  const CoursesLoaded(this.courses, this.categories);
  @override
  List<Object?> get props => [courses, categories];
}

class CourseDetailLoaded extends TrainingState {
  final CourseModel course;
  const CourseDetailLoaded(this.course);
  @override
  List<Object?> get props => [course];
}

class MyLearningLoaded extends TrainingState {
  final List<CourseModel> inProgress;
  final List<CourseModel> completed;
  const MyLearningLoaded(this.inProgress, this.completed);
  @override
  List<Object?> get props => [inProgress, completed];
}

class CertificatesLoaded extends TrainingState {
  final List<CertificateModel> certificates;
  const CertificatesLoaded(this.certificates);
  @override
  List<Object?> get props => [certificates];
}

class EnrolledSuccess extends TrainingState {}
class TrainingRequestSubmitted extends TrainingState {}

class TrainingError extends TrainingState {
  final Failure failure;
  const TrainingError(this.failure);
  @override
  List<Object?> get props => [failure];
}
