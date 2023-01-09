part of 'helpers.dart';

class Debouncer<T> {
  final Duration duration;
  void Function(T value) onValue;
  T _value;
  Timer _timer;

  Debouncer({this.duration, this.onValue});

  T get value => this._value;

  set value(T val) {
    _value = val;
    _timer?.cancel();
    _timer = Timer(duration, () => this.onValue(_value));
  }
}
