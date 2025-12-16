import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'quizzes_state.dart';

class QuizzesCubit extends Cubit<QuizzesState> {
  final FirebaseFirestore _firestore;
  final String courseId;
  StreamSubscription<QuerySnapshot>? _quizzesSubscription;

  QuizzesCubit({
    required this.courseId,
    FirebaseFirestore? firestore,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        super(QuizzesInitial()) {
    _startListening();
  }

  /// Start listening to quizzes collection in real-time for a specific course
  void _startListening() {
    emit(QuizzesLoading());

    _quizzesSubscription?.cancel();
    _quizzesSubscription = _firestore
        .collection('courses')
        .doc(courseId)
        .collection('quizzes')
        .snapshots()
        .listen(
      (snapshot) {
        try {
          final quizzes = snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'id': doc.id,
              'name': data['name'] ?? 'Unnamed Quiz',
              'date': data['date'] ?? '',
              'duration': data['duration'] ?? '30 min',
              'description': data['description'] ?? '',
            };
          }).toList();

          // Sort by name locally
          quizzes.sort(
              (a, b) => (a['name'] as String).compareTo(b['name'] as String));

          emit(QuizzesLoaded(quizzes));
        } catch (e) {
          emit(QuizzesError('Failed to load quizzes: $e'));
        }
      },
      onError: (error) {
        emit(QuizzesError('Error listening to quizzes: $error'));
      },
    );
  }

  /// Manually refresh quizzes (reconnects the listener)
  Future<void> refreshQuizzes() async {
    _startListening();
  }

  /// Load quizzes once (non-realtime, for backward compatibility)
  Future<void> loadQuizzes() async {
    emit(QuizzesLoading());
    try {
      final snapshot = await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('quizzes')
          .get();

      final quizzes = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] ?? 'Unnamed Quiz',
          'date': data['date'] ?? '',
          'duration': data['duration'] ?? '30 min',
          'description': data['description'] ?? '',
        };
      }).toList();

      emit(QuizzesLoaded(quizzes));
    } catch (e) {
      emit(QuizzesError('Failed to load quizzes: $e'));
    }
  }

  @override
  Future<void> close() {
    _quizzesSubscription?.cancel();
    return super.close();
  }
}
