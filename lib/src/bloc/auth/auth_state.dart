part of 'auth_bloc.dart';

class AuthState {
  bool uninitialized;
  bool loading;
  bool authenticated;
  bool needResetPass;
  bool isErrorAuth;
  String errorLogin;

  AuthState(
      {this.uninitialized = false,
      this.loading = false,
      this.authenticated = false,
      this.isErrorAuth = false,
      this.needResetPass = false,
      this.errorLogin});

  AuthState copyWith(
          {bool uninitialized,
          bool loading,
          bool authenticated,
          bool isErrorAuth,
          bool needResetPass,
          String errorLogin}) =>
      new AuthState(
          uninitialized: uninitialized ?? this.uninitialized,
          loading: loading ?? this.loading,
          authenticated: authenticated ?? this.authenticated,
          isErrorAuth: isErrorAuth ?? this.isErrorAuth,
          needResetPass: needResetPass ?? this.needResetPass,
          errorLogin: errorLogin ?? this.errorLogin);
}
