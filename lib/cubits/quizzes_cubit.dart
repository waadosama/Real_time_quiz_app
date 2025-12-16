import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/quiz.dart';

part 'quizzes_state.dart';

class QuizzesCubit extends Cubit<QuizzesState> {
  final FirebaseFirestore _firestore;
  final String courseId;
  StreamSubscription<QuerySnapshot>? _quizzesSubscription;

  QuizzesCubit({
    required this.courseId,
    FirebaseFirestore? firestore,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        super(const QuizzesState()) {
    _startListening();
  }

  void _startListening() {
    emit(state.copyWith(status: QuizzesStatus.loading));

    _quizzesSubscription?.cancel();
    _quizzesSubscription = _firestore
        .collection('quizzes')
        .where('courseId', isEqualTo: courseId)
        .snapshots()
        .listen(
      (snapshot) {
        try {
          final quizzes = snapshot.docs
              .map((doc) => QuizModel.fromJson(doc.data(), id: doc.id))
              .toList()
            ..sort((a, b) => a.name.compareTo(b.name));

          emit(
            state.copyWith(
              status: QuizzesStatus.success,
              quizzes: quizzes,
              errorMessage: null,
            ),
          );
        } catch (e) {
          emit(
            state.copyWith(
              status: QuizzesStatus.failure,
              errorMessage: 'Failed to load quizzes: $e',
            ),
          );
        }
      },
      onError: (error) {
        emit(
          state.copyWith(
            status: QuizzesStatus.failure,
            errorMessage: 'Error listening to quizzes: $error',
          ),
        );
      },
    );
  }

  Future<void> refreshQuizzes() async {
    _startListening();
  }

  @override
  Future<void> close() {
    _quizzesSubscription?.cancel();
    return super.close();
  }
}
