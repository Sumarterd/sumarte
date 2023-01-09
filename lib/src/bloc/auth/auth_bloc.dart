import 'package:sumarte/src/bloc/request/request_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sumarte/src/services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthenticationService authService;

  RequestBloc requestBloc;
  AuthBloc({AuthState initialState, this.authService}) : super(initialState);

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AppStarted) {
      final bool user = await AuthenticationService.loggedUser();
      if (user) {
        yield state.copyWith(authenticated: true);
      }
    } else if (event is LoginButtonPressed) {
      yield state.copyWith(loading: true);

      final resp = await authService.signIn(
          username: event.user, password: event.password);

      if (resp['OK']) {
        yield state.copyWith(
            loading: false,
            authenticated: true,
            isErrorAuth: false,
            needResetPass: (resp["user"].needResetPass.toLowerCase() == '1'));
      } else {
        yield state.copyWith(
            loading: false,
            authenticated: false,
            isErrorAuth: true,
            errorLogin: resp['mensaje']);
      }
    } else if (event is LoggedOut) {
      yield state.copyWith(loading: true);
      final resp = await authService.logout();
      if (resp) {
        requestBloc = RequestBloc();
        requestBloc.add(RequestLoad(load: false));
        yield state.copyWith(authenticated: false);
      }
      yield state.copyWith(loading: false);
    }
  }

  Future<bool> hasToken() async {
    return false;
  }

  @override
  Future<void> close() {
    requestBloc?.close();
    return super.close();
  }
}
