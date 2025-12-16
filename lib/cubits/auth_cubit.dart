import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/models/user_model.dart';
import 'package:quiz_app/services/storage_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final StorageService storageService;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthCubit({required this.storageService}) : super(AuthInitial()) {
    _checkInitialAuthState();
    _listenToAuthChanges();
  }

  // Check initial auth state
  Future<void> _checkInitialAuthState() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      try {
        final token = await firebaseUser.getIdToken();
        final user = UserModel(
          username: firebaseUser.displayName ??
              firebaseUser.email?.split('@')[0] ??
              'User',
          email: firebaseUser.email ?? '',
          token: token,
          loginTime: DateTime.now(),
        );
        await storageService.saveUser(user);
        emit(AuthAuthenticated(user));
      } catch (e) {
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  // Listen to auth state changes
  void _listenToAuthChanges() {
    _auth.authStateChanges().listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        // User is signed in
        try {
          final token = await firebaseUser.getIdToken();
          final user = UserModel(
            username: firebaseUser.displayName ??
                firebaseUser.email?.split('@')[0] ??
                'User',
            email: firebaseUser.email ?? '',
            token: token,
            loginTime: DateTime.now(),
          );
          await storageService.saveUser(user);
          emit(AuthAuthenticated(user));
        } catch (e) {
          emit(AuthError('Failed to get user token: ${e.toString()}'));
        }
      } else {
        // User is signed out
        await storageService.clearUser();
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());

      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        final token = await firebaseUser.getIdToken();
        final user = UserModel(
          username: firebaseUser.displayName ??
              firebaseUser.email?.split('@')[0] ??
              'User',
          email: firebaseUser.email ?? '',
          token: token,
          loginTime: DateTime.now(),
        );

        await storageService.saveUser(user);
        emit(AuthAuthenticated(user));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many requests. Please try again later.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Sign in with email and password is not enabled.';
          break;
        default:
          errorMessage = e.message ?? 'Authentication failed.';
      }
      emit(AuthError(errorMessage));
    } catch (e) {
      emit(AuthError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());

      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        // Update display name
        await firebaseUser.updateDisplayName(username);
        await firebaseUser.reload();
        final updatedUser = _auth.currentUser;

        if (updatedUser != null) {
          final token = await updatedUser.getIdToken();
          final user = UserModel(
            username: username,
            email: email.trim(),
            token: token,
            loginTime: DateTime.now(),
          );

          await storageService.saveUser(user);
          emit(AuthAuthenticated(user));
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred';
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists for that email.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Sign up with email and password is not enabled.';
          break;
        default:
          errorMessage = e.message ?? 'Registration failed.';
      }
      emit(AuthError(errorMessage));
    } catch (e) {
      emit(AuthError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> logout() async {
    try {
      emit(AuthLoading());
      await _auth.signOut();
      await storageService.clearUser();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Failed to logout: ${e.toString()}'));
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Failed to send password reset email');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  UserModel? getCurrentUser() {
    return storageService.getUser();
  }

  User? getFirebaseUser() {
    return _auth.currentUser;
  }
}
