import 'package:sumarte/src/models/HistoryPayment.dart';
import 'package:sumarte/src/models/UserTransneg.dart';

abstract class HistoryPaymentEvent {}
abstract class InvoiceEvent {}
class HistoryPaymentLoad extends HistoryPaymentEvent {
  final bool load;
  final List<HistoryPayment> paHistory;
  HistoryPaymentLoad({this.load, this.paHistory});
  @override
  String toString() => 'HistoryPaymentLoad';
}

class InvoiceLoad extends InvoiceEvent {
  final bool load;
  final UserTransneg pInvoice;
  InvoiceLoad({this.load, this.pInvoice});
  @override
  String toString() => 'InvoiceLoad';
}