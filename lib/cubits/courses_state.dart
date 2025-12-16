part of 'courses_cubit.dart';

abstract class CoursesState {}

class CoursesInitial extends CoursesState {}

class CoursesLoading extends CoursesState {}

class CoursesLoaded extends CoursesState {
  final List<Map<String, dynamic>> courses;
  CoursesLoaded(this.courses);
}

class CoursesError extends CoursesState {
  final String message;
  CoursesError(this.message);
}
