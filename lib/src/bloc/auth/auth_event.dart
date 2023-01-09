part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AppStarted extends AuthEvent {
  @override
  String toString() => 'AppStarted';
}

class LoginButtonPressed extends AuthEvent {
  final String user;
  final String password;
  LoginButtonPressed({this.user, this.password});
}

class ValidateSession extends AuthEvent {}

class LoggedOut extends AuthEvent {
  @override
  String toString() => 'LoggedOut';
}
