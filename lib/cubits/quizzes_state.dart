part of 'quizzes_cubit.dart';

abstract class QuizzesState {}

class QuizzesInitial extends QuizzesState {}

class QuizzesLoading extends QuizzesState {}

class QuizzesLoaded extends QuizzesState {
  final List<Map<String, dynamic>> quizzes;
  QuizzesLoaded(this.quizzes);
}

class QuizzesError extends QuizzesState {
  final String message;
  QuizzesError(this.message);
}
