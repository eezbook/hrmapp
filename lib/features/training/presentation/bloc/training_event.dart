import 'package:equatable/equatable.dart';

abstract class TrainingEvent extends Equatable {
  const TrainingEvent();
  @override
  List<Object?> get props => [];
}

class LoadCourses extends TrainingEvent {
  final String? category;
  final String? search;
  const LoadCourses({this.category, this.search});
  @override
  List<Object?> get props => [category, search];
}
class LoadCourse extends TrainingEvent {
  final int id;
  const LoadCourse(this.id);
  @override
  List<Object?> get props => [id];
}
class EnrollCourse extends TrainingEvent {
  final int id;
  const EnrollCourse(this.id);
  @override
  List<Object?> get props => [id];
}
class LoadMyLearning extends TrainingEvent {}
class LoadCertificates extends TrainingEvent {}
