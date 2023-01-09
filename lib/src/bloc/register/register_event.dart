part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class RegisterButtonPressed extends RegisterEvent {
  final String name;
  final String lastname;
  final String tipoDoc;
  final String documentNumber;
  final String phone;
  final String email;
  final String password;

  RegisterButtonPressed(
      {this.name,
      this.lastname,
      this.documentNumber,
      this.tipoDoc,
      this.phone,
      this.email,
      this.password});
}
