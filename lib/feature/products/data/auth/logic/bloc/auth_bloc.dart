import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:with_api/feature/products/data/services/api/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    // Registering event handlers
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    // on<AuthCheckStatusRequested>(_onCheckStatusRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final bool emailExists = await _authRepository.checkIfUserExists(
        event.email,
      );

      if (emailExists) {
        emit(
          AuthError(
            'This email address is already registered. Try logging in instead.',
          ),
        );
        return;
      }

      await _authRepository.registerUser(
        name: event.name,
        email: event.email,
        password: event.password,
      );

      final token = await _authRepository.loginUser(
        email: event.email,
        password: event.password,
      );

      emit(AuthAuthenticated(token));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final token = await _authRepository.loginUser(
        email: event.email,
        password: event.password,
      );

      // await PreferenceService.saveToken(token);
      // await PreferenceService.saveUserEmail(event.email);

      emit(AuthAuthenticated(token));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  // /// 🔄 Handle App Startup Checking
  // Future<void> _onCheckStatusRequested(
  //   AuthCheckStatusRequested event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   final token = await PreferenceService.getToken();
  //   if (token != null && token.isNotEmpty) {
  //     emit(AuthAuthenticated(token));
  //   } else {
  //     emit(AuthUnauthenticated());
  //   }
  // }

  /// 🚪 Handle Logout
  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    // await PreferenceService.clearAuthData(); // Clean up shared preferences
    emit(AuthUnauthenticated());
  }
}
