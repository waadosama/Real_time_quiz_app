import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/models/user_model.dart';
import 'package:quiz_app/services/storage_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final StorageService storageService;

  AuthCubit({required this.storageService}) : super(AuthInitial()) {
    _checkLoginStatus();
  }


  Future<void> _checkLoginStatus() async {
    try {
      if (storageService.isLoggedIn()) {
        final user = storageService.getUser();
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }


  Future<void> login({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());

      final user = UserModel(
        username: username,
        email: email,
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        loginTime: DateTime.now(),
      );

      await storageService.saveUser(user);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }


  Future<void> logout() async {
    try {
      emit(AuthLoading());
      await storageService.clearUser();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

 
  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      final user = UserModel(
        username: username,
        email: email,
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        loginTime: DateTime.now(),
      );

      await storageService.saveUser(user);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  UserModel? getCurrentUser() {
    return storageService.getUser();
  }


}

class CoursesCubit extends Cubit<CoursesState> {
  final FirebaseFirestore _firestore;

  CoursesCubit({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        super(CoursesInitial());

  /// Load courses from Firebase once (not watching)
  Future<void> loadCourses() async {
    emit(CoursesLoading());
    try {
      final snapshot = await _firestore.collection('courses').get();

      final courses = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] ?? 'Unnamed Course',
          'imagePath': data['imagePath'] ?? 'assets/images/exam.png',
          'description': data['description'] ?? '',
        };
      }).toList();

      emit(CoursesLoaded(courses));
    } catch (e) {
      emit(CoursesError('Failed to load courses: $e'));
    }
  }

  /// Refresh courses
  Future<void> refreshCourses() => loadCourses();
}
