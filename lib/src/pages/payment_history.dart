import 'dart:ui';
import 'package:sumarte/src/bloc/invoice/invoice_bloc.dart';
import 'package:sumarte/src/bloc/invoice/invoice_event.dart';
import 'package:sumarte/src/config/app_theme.dart';
import 'package:sumarte/src/models/HistoryPayment.dart';
import 'package:sumarte/src/models/user.dart';
import 'package:sumarte/src/services/auth_service.dart';
import 'package:sumarte/src/services/invoice_service.dart';
import 'package:sumarte/src/share_prefs/preferences_storage.dart';
import 'package:sumarte/src/widgets/circular_indicatiors_widget.dart';
import 'package:flutter/material.dart';

// ignore: unused_import
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({Key key, this.animationController})
      : super(key: key);
  final AnimationController animationController;

  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  InvoiceService invoiceService;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  List<HistoryPayment> _items = [];
  bool isLoading = true;
  HistoryPaymentBloc historyPaymentBloc;
  PreferenceStorage preferenceStorage;
  TextEditingController editingController = TextEditingController();
  String queryString = '';

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    invoiceService = new InvoiceService();
    _refreshIndicatorKey.currentState?.show();
    historyPaymentBloc = HistoryPaymentBloc();
    _loadItems(load: true);
  }

  void filterSearchResults(String query) {
    List<HistoryPayment> listData = List<HistoryPayment>();

    if (query != "") {
      _loadItems(load: false);
      var result = _items
          .indexWhere((element) => element.invoice_number.contains(query));
      if (result >= 0) {
        listData.add(_items[result]);

        if (mounted) {
          setState(() {
            _items.clear();
            _items.addAll(listData);
          });
        }
        return;
      } else {
        _items.clear();
      }
    } else {
      _loadItems(load: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicatorWidget());
    }
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () => _loadItems(load: true),
      child: Container(
        margin: EdgeInsets.only(top: 150),
        height: MediaQuery.of(context).size.height * 0.6697,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                  queryString = value;
                },
                controller: editingController,
                cursorColor: AppTheme.nearlyDarkOrange,
                decoration: InputDecoration(
                  labelText: "Factura",
                  hintText: "",
                  hintStyle: TextStyle(color: AppTheme.nearlyDarkOrange),
                  prefixIcon:
                      Icon(Icons.search, color: AppTheme.nearlyDarkOrange),
                  enabledBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: AppTheme.nearlyDarkOrange),
                  ),
                  focusedBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: AppTheme.nearlyDarkOrange),
                  ),
                ),
              ),
            ),
            _items.length == 0
                ? Container(
                    alignment: Alignment.center,
                    child: Text(
                      'No se encontraron facturas con el ID: ' + queryString,
                      style: TextStyle(fontSize: 15),
                    ),
                  )
                : new Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 3),
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: _items.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return cardWidget(historyPayment: _items[index]);
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Future _loadItems({bool load}) async {
    if (mounted) {
      if (load == false) {
        preferenceStorage = PreferenceStorage();

        if (preferenceStorage.getValue(key: "historyPaymentLoad") == 'true') {
          setState(() {
            _items = HistoryPayment.decode(
                preferenceStorage.getValue(key: "paHistory").toString());
            isLoading = false;
          });
          return;
        }
      }

      AuthenticationService auth = AuthenticationService();
      final User user = auth.getUserLogged();
      final items =
          await invoiceService.getPaymentHistory(userId: user.id, code: "00");

      if (items['OK']) {
        historyPaymentBloc
            .add(HistoryPaymentLoad(load: true, paHistory: items['data']));
        setState(() {
          _items = items['data'];
          isLoading = false;
        });
        _refreshIndicatorKey.currentState?.show();
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget cardWidget({HistoryPayment historyPayment}) {
    String documentoFecha = DateFormat.yMMMMd('es_PR')
        .format(DateTime.parse(historyPayment.date_created));

    return GestureDetector(
      child: Column(
        children: <Widget>[
          Container(
            width: 400,
            height: 145,
            child: Card(
              elevation: 2,
              shape: Border(
                  right: BorderSide(
                      color:  AppTheme.darkerText,
                      width: 2),
                  left: BorderSide(
                      color:  AppTheme.darkerText,
                      width: 2)
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 10.0,
                    right: 10.0,
                    child: Container(
                      width: 200.0,
                      height: 250.0,
                      color: AppTheme.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: 150.0,
                                  height: 25.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    border: Border.all(
                                        width: 2.0, color: Colors.green),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Codigo: ${historyPayment.approval_code}",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Text(
                                        "No. Factura: ${historyPayment.invoice_number}",
                                        style: TextStyle(
                                            color: AppTheme.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Column(
                                children: <Widget>[
                                  ticketDetailsWidget(
                                      'No. Tarjeta',
                                      "[ ${historyPayment.card_number} ]",
                                      'Fecha',
                                      "${documentoFecha}"),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Container(
                                      height: 1.0,
                                      color: AppTheme.grey,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, right: 40.0),
                                    child: Center(
                                      child: Text(
                                        "${NumberFormat.currency(name: "RD\$ ").format(double.tryParse(historyPayment.amount))}",
                                        style: TextStyle(
                                          color: AppTheme.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Container(
                                height: 1.0,
                                color: AppTheme.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ticketDetailsWidget(String firstTitle, String firstDesc,
      String secondTitle, String secondDesc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                firstTitle,
                style: TextStyle(
                    color: AppTheme.grey, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  firstDesc,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                secondTitle,
                style: TextStyle(
                    color: AppTheme.grey, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  secondDesc,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
