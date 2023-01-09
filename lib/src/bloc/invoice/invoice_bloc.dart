import 'package:sumarte/src/models/HistoryPayment.dart';
import 'package:sumarte/src/models/UserTransneg.dart';
import 'package:sumarte/src/share_prefs/preferences_storage.dart';
import 'package:bloc/bloc.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';


class HistoryPaymentBloc extends Bloc<HistoryPaymentEvent, HistoryPaymentState> {
  PreferenceStorage preferenceStorage = PreferenceStorage();
  HistoryPaymentBloc() : super(HistoryPaymentState(paymentHistoryload: false));

  @override
  Stream<HistoryPaymentState> mapEventToState(
      HistoryPaymentEvent event,
      ) async* {
    if (event is HistoryPaymentLoad) {
      if (event.load) {
        await preferenceStorage.setValue(
            key: "paHistory", value: HistoryPayment.encode(event.paHistory));

        await preferenceStorage.setValue(
            key: "historyPaymentLoad", value: event.load.toString());
      } else {
        preferenceStorage.deleteValue(key: "paHistory");
        preferenceStorage.deleteValue(key: "historyPaymentLoad");
      }

      yield state.copyWith(paymentHistoryload: event.load);
    }
  }
}
class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  PreferenceStorage preferenceStorage = PreferenceStorage();
  InvoiceBloc() : super(InvoiceState(invoiceLoad: false));

  @override
  Stream<InvoiceState> mapEventToState(
      InvoiceEvent event,
      ) async* {
    if (event is InvoiceLoad) {
      if (event.load) {
        await preferenceStorage.setValue(
            key: "pInvoice", value: UserTransneg.encode(event.pInvoice));

        await preferenceStorage.setValue(
            key: "invoiceLoad", value: event.load.toString());
      } else {
        preferenceStorage.deleteValue(key: "pInvoice");
        preferenceStorage.deleteValue(key: "invoiceLoad");
      }

      yield state.copyWith(invoiceLoad: event.load);
    }
  }
}