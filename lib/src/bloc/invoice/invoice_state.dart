import 'package:sumarte/src/models/HistoryPayment.dart';
import 'package:sumarte/src/models/UserTransneg.dart';

class HistoryPaymentState {
  bool paymentHistoryload;
  List<HistoryPayment> paHistory;
  HistoryPaymentState({this.paymentHistoryload = false, this.paHistory});

  HistoryPaymentState copyWith({bool paymentHistoryload, List<HistoryPayment> paHistory}) =>
      new HistoryPaymentState(
          paymentHistoryload: paymentHistoryload ?? this.paymentHistoryload,
          paHistory: paHistory ?? this.paHistory);
}
class InvoiceState {
  bool invoiceLoad;
  UserTransneg pInvoice;
  InvoiceState({this.invoiceLoad = false, this.pInvoice});

  InvoiceState copyWith({bool invoiceLoad, UserTransneg pInvoice}) =>
      new InvoiceState(
          invoiceLoad: invoiceLoad ?? this.invoiceLoad,
          pInvoice: pInvoice ?? this.pInvoice);
}