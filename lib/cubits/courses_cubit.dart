import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/course.dart';

part 'courses_state.dart';

class CoursesCubit extends Cubit<CoursesState> {
  CoursesCubit({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        super(const CoursesState()) {
    _startListening();
  }

  final FirebaseFirestore _firestore;
  StreamSubscription<QuerySnapshot>? _coursesSubscription;

  void _startListening() {
    emit(state.copyWith(status: CoursesStatus.loading));

    _coursesSubscription?.cancel();
    _coursesSubscription = _firestore.collection('courses').snapshots().listen(
      (snapshot) {
        try {
          final courses = snapshot.docs.map((doc) {
            final data = doc.data();
            return CourseModel.fromJson(data, id: doc.id);
          }).toList()
            ..sort((a, b) => a.name.compareTo(b.name));

          emit(
            state.copyWith(
              status: CoursesStatus.success,
              courses: courses,
              errorMessage: null,
            ),
          );
        } catch (e) {
          emit(
            state.copyWith(
              status: CoursesStatus.failure,
              errorMessage: 'Failed to load courses: $e',
            ),
          );
        }
      },
      onError: (error) {
        emit(
          state.copyWith(
            status: CoursesStatus.failure,
            errorMessage: 'Error listening to courses: $error',
          ),
        );
      },
    );
  }

  Future<void> refreshCourses() async {
    _startListening();
  }

  @override
  Future<void> close() {
    _coursesSubscription?.cancel();
    return super.close();
  }
}
