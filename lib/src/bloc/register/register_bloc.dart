import 'dart:async';

import 'package:sumarte/src/services/auth_service.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  AuthenticationService authService;

  RegisterBloc({RegisterState initialState, this.authService})
      : super(initialState);

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is RegisterButtonPressed) {
      final resp = await authService.register(
          name: event.name,
          lastname: event.lastname,
          email: event.email,
          password: event.password,
          phone: event.phone,
          documentType: event.tipoDoc,
          identificationCard: event.documentNumber);

      if (resp['OK']) {
        yield state.copyWith(
            loading: false, registrado: true, errorRegistro: "");
      } else {
        yield state.copyWith(
            loading: false, registrado: false, errorRegistro: resp['mensaje']);
      }
    }
  }
}
