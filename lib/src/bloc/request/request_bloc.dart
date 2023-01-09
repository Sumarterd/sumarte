import 'dart:async';

import 'package:sumarte/src/models/Request.dart';
import 'package:sumarte/src/share_prefs/preferences_storage.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  PreferenceStorage preferenceStorage = PreferenceStorage();
  RequestBloc() : super(RequestState(requestload: false));

  @override
  Stream<RequestState> mapEventToState(
    RequestEvent event,
  ) async* {
    if (event is RequestLoad) {
      if (event.load) {
        await preferenceStorage.setValue(
            key: "requests", value: Request.encode(event.requests));

        await preferenceStorage.setValue(
            key: "requestLoad", value: event.load.toString());
      } else {
        preferenceStorage.deleteValue(key: "requests");
        preferenceStorage.deleteValue(key: "requestLoad");
      }

      yield state.copyWith(requestload: event.load);
    }
  }
}
