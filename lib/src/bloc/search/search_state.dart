part of 'search_bloc.dart';

class SearchState {
  final bool seleccionManual;
  final List<SearchResult> history;

  SearchState({
    List<SearchResult> history,
    this.seleccionManual = false,
  }) : this.history = (history ?? []);

  SearchState copyWith(
          {bool seleccionManual,
          List<SearchResult> history,
          bool seachbarShow}) =>
      SearchState(
          seleccionManual: seleccionManual ?? this.seleccionManual,
          history: history ?? this.history);
}
