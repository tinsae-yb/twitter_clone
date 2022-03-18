part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {}

class UnAuthenticated extends AuthState {}

class Authenticating extends AuthState {}

class AuthenticatingFailed extends AuthState {
  final String message;

  AuthenticatingFailed(this.message);
}
