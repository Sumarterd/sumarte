part of 'request_bloc.dart';

class RequestState {
  bool requestload;
  List<Request> requests;
  RequestState({this.requestload = false, this.requests});

  RequestState copyWith({bool requestload, List<Request> requests}) =>
      new RequestState(
          requestload: requestload ?? this.requestload,
          requests: requests ?? this.requests);
}