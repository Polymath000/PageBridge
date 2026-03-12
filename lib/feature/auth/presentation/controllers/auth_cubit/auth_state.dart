part of 'auth_cubit.dart';

/// Base state for Notion OAuth flow.
sealed class AuthState {
  const AuthState();
}

/// Idle state before any action.
final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Emitted while signing in.
final class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Emitted when sign-in succeeds.
final class AuthSuccess extends AuthState {
  final AuthTokenEntity token;
  const AuthSuccess({required this.token});
}

/// Emitted when sign-in fails.
final class AuthFailure extends AuthState {
  final String message;
  const AuthFailure({required this.message});
}
