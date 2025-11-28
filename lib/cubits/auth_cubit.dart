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
