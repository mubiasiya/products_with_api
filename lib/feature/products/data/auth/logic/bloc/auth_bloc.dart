import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:with_api/feature/products/data/auth/services/api/auth_service.dart';
import 'package:with_api/feature/products/data/auth/services/shared_pref/auth_shared.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLoginRequested>(_onLoginRequested);
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

      await PreferenceService.saveLoginDetails(
        token: token,
        email: event.email,
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
      await PreferenceService.saveLoginDetails(
        token: token,
        email: event.email,
      );

      emit(AuthAuthenticated(token));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

 
  
  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await PreferenceService.clearAuthData(); 
    emit(AuthUnauthenticated());
  }
}
