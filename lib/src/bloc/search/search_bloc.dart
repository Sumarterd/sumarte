import 'dart:async';

import 'package:sumarte/src/models/search_result.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({SearchState initialState}) : super(initialState);
  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is OnActivarMarcadorManual) {
      yield state.copyWith(seleccionManual: true, seachbarShow: false);
    } else if (event is OnDesActivarMarcadorManual) {
      yield state.copyWith(seleccionManual: false, seachbarShow: true);
    } else if (event is ShowSearchBar) {
      yield state.copyWith(seachbarShow: true);
    } else if (event is HideSearchBar) {
      yield state.copyWith(seachbarShow: false);
    } else if (event is OnAddHistory) {
      final exist = state.history
          .where((result) => result.nombreDestino == event.result.nombreDestino)
          .length;

      if (exist == 0) {
        final newHistory = [...state.history, event.result];
        yield state.copyWith(history: newHistory);
      }
    }
  }
}
