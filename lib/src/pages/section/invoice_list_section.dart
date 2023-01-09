import 'package:sumarte/src/bloc/invoice/invoice_bloc.dart';
import 'package:sumarte/src/bloc/invoice/invoice_event.dart';
import 'package:sumarte/src/config/app_theme.dart';
import 'package:sumarte/src/config/main_full_view.dart';
import 'package:sumarte/src/models/Contracts.dart';
import 'package:sumarte/src/models/InvoiceTransneg.dart';
import 'package:sumarte/src/models/UserTransneg.dart';
import 'package:sumarte/src/models/user.dart';
import 'package:sumarte/src/services/auth_service.dart';
import 'package:sumarte/src/services/invoice_service.dart';
import 'package:sumarte/src/share_prefs/preferences_storage.dart';
import 'package:sumarte/src/widgets/circular_indicatiors_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceListSection extends StatefulWidget {
  static final routeName = '/invoce';

  const InvoiceListSection(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);
  final AnimationController mainScreenAnimationController;
  final Animation<double> mainScreenAnimation;

  @override
  _InvoiceListSectionState createState() => _InvoiceListSectionState();
}

class _InvoiceListSectionState extends State<InvoiceListSection>
    with TickerProviderStateMixin {
  AnimationController animationController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final InvoiceService invoiceService = InvoiceService();
  final AuthenticationService authenticationService = AuthenticationService();
  String statusInvoice;
  UserTransneg _items;
  bool isLoading = true;
  InvoiceBloc invoiceBloc;
  PreferenceStorage preferenceStorage;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _refreshIndicatorKey.currentState?.show();
    invoiceBloc = InvoiceBloc();
    _loadItems(load: true);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicatorWidget());
    }

    if (_items.codigoRespuesta != 'C0007') {
      return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () => _loadItems(load: true),
        child: Container(
          margin: const EdgeInsets.only(left: 7, right: 7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              btnPaymentHistory(0),
              SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  width: 400,
                  height: (_items.montoAdeudado > 0.0) ? 145 : 102,
                  child: Card(
                    shape: Border(
                        right: BorderSide(
                            color: (_items.montoAdeudado > 0.0)
                                ? AppTheme.redText
                                : AppTheme.greenApp,
                            width: 5)),
                    elevation: 5,
                    child: Column(children: <Widget>[
                      ListTile(
                        leading: Icon(
                          Icons.money_off,
                          color: Colors.green,
                        ),
                        subtitle: Row(
                          children: <Widget>[
                            Text(
                              "Deuda total: ",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),

                            Text(
                              NumberFormat.currency(name: "RD\$ ")
                                  .format(_items.montoAdeudado),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: (_items.montoAdeudado > 0.0)
                                      ? AppTheme.redText
                                      : AppTheme.greenApp),
                            ),
                          ],
                        ),
                        title: Text(
                          _items.nombreTitular.toString(),
                        ),
                      ),
                      (_items.montoAdeudado > 0.0)
                          ? Container(
                              width: 320,
                              height: 45,
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MainFullViewer(
                                              identificationPage: "card")));
                                  setInvoiceData(_items.montoAdeudado, "0");
                                },
                                style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          EdgeInsets.all(0)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          side: BorderSide(
                                              color: AppTheme.white))),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 60.0,
                                  decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    gradient: new LinearGradient(colors: [
                                      Color.fromARGB(255, 6, 95, 195),
                                      Color.fromARGB(255, 66, 165, 245),
                                    ]),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(0),
                                  child: Text(
                                    "PAGAR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.white,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                            )
                          :  Text('')
                    ]),
                  ),
                ),
              ),
              _items.contratosAsociados.length > 0
                  ? ListView.builder(
                      padding: EdgeInsets.only(top: 10),
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: _items.contratosAsociados.length,
                      itemBuilder: (context, index) {
                        Contracts contracts = _items.contratosAsociados[index];
                        return this.cardWidget(contracts: contracts);
                      },
                    )
                  : Text(""),
            ],
          ),
        ),
      );
    } else {
      return Container(
          margin: const EdgeInsets.only(left: 7, right: 7),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.55,
          child: Column(
            children: [
              Card(
                child: Image(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/notfound.gif'),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 130,
                child: Card(
                  child: Column(
                    children: [
                      Padding(padding: const EdgeInsets.all(25)),
                      Text(
                          _items.codigoRespuesta +
                              " - " +
                              _items.descripcionRespuesta,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 17,
                              color: AppTheme.nearlyOrgane,
                              fontFamily: AppTheme.fontName))
                    ],
                  ),
                ),
              )
            ],
          ));
    }
  }

  Future _loadItems({bool load}) async {
    if (mounted) {
      if (load == false) {
        preferenceStorage = PreferenceStorage();

        if (preferenceStorage.getValue(key: "invoiceLoad") == 'true') {
          setState(() {
            _items = UserTransneg.decode(
                preferenceStorage.getValue(key: "pInvoice").toString());
            isLoading = false;
          });
          return;
        }
      }
      AuthenticationService auth = AuthenticationService();
      final User user = auth.getUserLogged();
      var items = await invoiceService.getInvocesPendding(user: user);
      invoiceBloc.add(InvoiceLoad(load: true, pInvoice: items));
      setState(() {
        _items = items;
        isLoading = false;
      });
      _refreshIndicatorKey.currentState?.show();
    }
  }

  Widget cardWidget({Contracts contracts}) {
    String documentoFecha = DateFormat.yMMMMd('es_PR')
        .format(DateTime.parse(contracts.documentoFecha));

    return GestureDetector(
      child: Column(
        children: <Widget>[
          Container(
            width: 400,
            height: 240,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 10.0,
                    right: 10.0,
                    child: ClipPath(
                      clipper: MyClipper(),
                      child: Container(
                        width: 200.0,
                        height: 450.0,
                        color: AppTheme.white,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: 150.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                      border: Border.all(
                                          width: 2.0, color: Colors.blue),
                                    ),
                                    child: Center(
                                      child: Text(
                                        (contracts.esClienteSubsidiado)
                                            ? "Subsidiado"
                                            : "No Subsidiado",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          (contracts.numeroContrato == null)
                                              ? "No. Contrato: N/A"
                                              : "No. Contrato: ${contracts.numeroContrato.toString()}",
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
                                        'Cant. Facturas',
                                        "[ ${contracts.facturas.length.toString()} ]",
                                        'Fecha Documento',
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
                                          "TITULAR: ${contracts.nombreTitular.toString()}",
                                          style: TextStyle(
                                            color: AppTheme.grey,
                                            fontSize: 13.0,
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
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 12.0),
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                    NumberFormat.currency(name: "RD\$ ")
                                        .format(contracts.montoTotal),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: AppTheme.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                              ),
                              new InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      isScrollControlled: false,
                                      context: context,
                                      elevation: 100,
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20)),
                                      ),
                                      builder: (context) {
                                        return Material(
                                          child: Scaffold(
                                            appBar: AppBar(
                                                backgroundColor:
                                                    AppTheme.nearlyDarkOrange,
                                                leading: Container(),
                                                title: Text(
                                                    'Listado de Facturas')),
                                            body: SafeArea(
                                              bottom: false,
                                              child: PageView(children: [
                                                contracts.facturas.length > 0
                                                    ? SingleChildScrollView(
                                                        child: Column(
                                                            children: <Widget>[
                                                            ListView.builder(
                                                              shrinkWrap: true,
                                                              physics:
                                                                  NeverScrollableScrollPhysics(),
                                                              itemCount:
                                                                  contracts
                                                                      .facturas
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                var invoice =
                                                                    contracts
                                                                            .facturas[
                                                                        index];
                                                                return ListTile(
                                                                  leading: Icon(
                                                                      Icons
                                                                          .list),
                                                                  title: Text((invoice
                                                                              .idFactura ==
                                                                          null)
                                                                      ? "N/A"
                                                                      : invoice
                                                                          .idFactura
                                                                          .toString()),
                                                                  subtitle: Text(NumberFormat.currency(
                                                                              name:
                                                                                  "RD\$ ")
                                                                          .format(invoice
                                                                              .montoAdeudado) +
                                                                      " - Fecha Ven.: " +
                                                                      DateFormat.yMd(
                                                                              'es_PR')
                                                                          .format(
                                                                              DateTime.parse(invoice.fechaVencimiento))),
                                                                  trailing:
                                                                      Container(
                                                                    child: Column(
                                                                        children: <
                                                                            Widget>[
                                                                          (invoice.idFactura != null)
                                                                              ? Column(
                                                                                  children: <Widget>[
                                                                                    btnCollect(invoice)
                                                                                  ],
                                                                                )
                                                                              : Text(
                                                                                  "NO PAGO",
                                                                                  style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.redText),
                                                                                )
                                                                        ]),
                                                                  ),
                                                                );
                                                              },
                                                            )
                                                          ]))
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0.0),
                                                        child: Center(
                                                          child: Text(
                                                            'No se encontraron facturas asociadas',
                                                            style: TextStyle(
                                                                fontSize: 15),
                                                          ),
                                                        ),
                                                      ),
                                              ]),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Column(
                                    children: [showInvoice()],
                                  ))
                            ],
                          ),
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

  Future<String> setInvoiceData(double amount, String invoiceNum) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('amount', amount);
    await prefs.setString('invoiceNum', invoiceNum);
  }

  Widget btnPaymentHistory(int align) {
    return Container(
        width: 200.0,
        height: 35.0,
        margin: (align == 0)
            ? const EdgeInsets.only(bottom: 7.0)
            : const EdgeInsets.only(left: 0.0, top: 7.0),
        child: Container(
          width: 60,
          height: 20,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainFullViewer(
                          identificationPage: "paymnetHistory")));
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(color: AppTheme.white))),
            ),
            child: Container(
              alignment: Alignment.center,
              height: 60.0,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                gradient: new LinearGradient(colors: [
                  Color.fromARGB(79, 66, 251, 111),
                  Color.fromARGB(79, 66, 221, 11)
                ]),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              padding: const EdgeInsets.all(0),
              child: Text(
                "HISTORICO DE PAGOS",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.white,
                    fontSize: 10),
              ),
            ),
          ),
        ));
  }

  Widget btnCollect(InvoiceTransneg invoice) {
    return Container(
      width: 80,
      height: 35,
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MainFullViewer(identificationPage: "card")));
          setInvoiceData(invoice.montoAdeudado, invoice.idFactura);
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: AppTheme.white))),
        ),
        child: Container(
          alignment: Alignment.center,
          height: 60.0,
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: new LinearGradient(colors: [
              Color.fromARGB(255, 6, 95, 195),
              Color.fromARGB(255, 66, 165, 245),
            ]),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          padding: const EdgeInsets.all(0),
          child: Text(
            "PAGAR",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.white,
                fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget showInvoice() {
    return Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ElevatedButton(
        onPressed: null,
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0),
                  side: BorderSide(color: AppTheme.white))),
        ),
        child: Container(
          alignment: Alignment.center,
          height: 50.0,
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(80.0),
            gradient: new LinearGradient(colors: [
              Color.fromARGB(255, 255, 136, 34),
              Color.fromARGB(255, 255, 177, 41)
            ]),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          padding: const EdgeInsets.all(0),
          child: Text(
            "VER FACTURAS",
            textAlign: TextAlign.center,
            style:
                TextStyle(fontWeight: FontWeight.bold, color: AppTheme.white),
          ),
        ),
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
                  color: AppTheme.grey,
                ),
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
                  color: AppTheme.grey,
                ),
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
    animationController.dispose();
    super.dispose();
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.addOval(Rect.fromCircle(
        center: Offset(0.0, size.height / 2 + 50.0), radius: 20.0));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width, size.height / 2 + 50.0), radius: 20.0));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
