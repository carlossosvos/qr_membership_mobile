import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  late StreamSubscription<User?> _authSubscription;

  AuthCubit(this._authService) : super(AuthInitial()) {
    _initializeAuthListener();
  }

  void _initializeAuthListener() {
    _authSubscription = _authService.authStateChanges.listen((user) {
      if (user != null) {
        if (user.emailVerified) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthEmailNotVerified(user));
        }
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      emit(AuthLoading());
      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // State will be updated by the stream listener
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      emit(AuthLoading());
      final credential = await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name if provided
      if (displayName != null && credential?.user != null) {
        await _authService.updateProfile(displayName: displayName);
      }

      // Send email verification
      await _authService.sendEmailVerification();

      // State will be updated by the stream listener
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      emit(AuthLoading());
      await _authService.signOut();
      // State will be updated by the stream listener
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      emit(AuthLoading());
      await _authService.sendPasswordResetEmail(email: email);
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await _authService.sendEmailVerification();
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    try {
      emit(AuthLoading());
      await _authService.updateProfile(
        displayName: displayName,
        photoURL: photoURL,
      );

      // Get updated user
      final user = _authService.currentUser;
      if (user != null) {
        emit(AuthAuthenticated(user));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> deleteAccount() async {
    try {
      emit(AuthLoading());
      await _authService.deleteAccount();
      // State will be updated by the stream listener
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void checkAuthStatus() {
    final user = _authService.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> reloadUser() async {
    try {
      final user = _authService.currentUser;
      if (user != null) {
        await user.reload();
        // This will trigger the auth state listener with updated user info
        final updatedUser = _authService.currentUser;
        if (updatedUser != null) {
          if (updatedUser.emailVerified) {
            emit(AuthAuthenticated(updatedUser));
          } else {
            emit(AuthEmailNotVerified(updatedUser));
          }
        }
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
