part of 'request_bloc.dart';

@immutable
abstract class RequestEvent {}

class RequestLoad extends RequestEvent {
  final bool load;
  final List<Request> requests;
  RequestLoad({this.load, this.requests});
  @override
  String toString() => 'RequestLoad';
}
