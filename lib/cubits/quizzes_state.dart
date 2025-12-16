part of 'quizzes_cubit.dart';

enum QuizzesStatus { initial, loading, success, failure }

class QuizzesState extends Equatable {
  const QuizzesState({
    this.status = QuizzesStatus.initial,
    this.quizzes = const <QuizModel>[],
    this.errorMessage,
  });

  final QuizzesStatus status;
  final List<QuizModel> quizzes;
  final String? errorMessage;

  QuizzesState copyWith({
    QuizzesStatus? status,
    List<QuizModel>? quizzes,
    String? errorMessage,
  }) {
    return QuizzesState(
      status: status ?? this.status,
      quizzes: quizzes ?? this.quizzes,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, quizzes, errorMessage];
}
