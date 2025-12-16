part of 'courses_cubit.dart';

enum CoursesStatus { initial, loading, success, failure }

class CoursesState extends Equatable {
  const CoursesState({
    this.status = CoursesStatus.initial,
    this.courses = const <CourseModel>[],
    this.errorMessage,
  });

  final CoursesStatus status;
  final List<CourseModel> courses;
  final String? errorMessage;

  CoursesState copyWith({
    CoursesStatus? status,
    List<CourseModel>? courses,
    String? errorMessage,
  }) {
    return CoursesState(
      status: status ?? this.status,
      courses: courses ?? this.courses,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, courses, errorMessage];
}
