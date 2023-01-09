part of 'register_bloc.dart';

class RegisterState {
  bool loading;
  bool registrado;
  String errorRegistro;

  RegisterState(
      {this.loading = false, this.registrado = false, this.errorRegistro = ""});

  RegisterState copyWith(
          {bool loading, bool registrado, String errorRegistro}) =>
      new RegisterState(
          loading: loading ?? this.loading,
          registrado: registrado ?? this.registrado,
          errorRegistro: errorRegistro ?? this.errorRegistro);
}
