import 'dart:ui';
import 'package:sumarte/src/bloc/request/request_bloc.dart';
import 'package:sumarte/src/config/app_theme.dart';
import 'package:sumarte/src/models/Request.dart';
import 'package:sumarte/src/models/user.dart';
import 'package:sumarte/src/services/auth_service.dart';
import 'package:sumarte/src/share_prefs/preferences_storage.dart';
import 'package:sumarte/src/widgets/circular_indicatiors_widget.dart';
import 'package:flutter/material.dart';
import 'package:sumarte/src/services/request_service.dart';
// ignore: unused_import
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

import '../request_details.dart';

class RequestDetailListSection extends StatefulWidget {
  const RequestDetailListSection(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);
  final AnimationController mainScreenAnimationController;
  final Animation<double> mainScreenAnimation;

  @override
  _RequestDetailListSectionState createState() =>
      _RequestDetailListSectionState();
}

class _RequestDetailListSectionState extends State<RequestDetailListSection>
    with TickerProviderStateMixin {
  AnimationController animationController;
  RequestService requestService;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  List<Request> _items = [];
  bool isLoading = true;
  RequestBloc requestBloc;
  PreferenceStorage preferenceStorage;
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    requestService = new RequestService();
    _refreshIndicatorKey.currentState?.show();
    requestBloc = RequestBloc();
    _loadItems(load: true);
  }
  void filterSearchResults(String query) {

    List<Request> listData = List<Request>();

    if(query != ""){
      _loadItems(load: false);
        var result = _items.indexWhere((element) => element.helpDeskId.contains(query));
        if (result >= 0) {
        listData.add(_items[result]);

    if (mounted) {
      setState(() {
        _items.clear();
        _items.addAll(listData);
      });
    }
    return;
    }else{
      _items.clear();
    }
    }else{
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
        height: MediaQuery.of(context).size.height * 0.65,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: TextField(
                onChanged: (value) {
                filterSearchResults(value);
                },
                controller: editingController,
                cursorColor: AppTheme.nearlyDarkOrange,
                decoration: InputDecoration(
                    labelText: "Buscar ID",
                    hintText: "",
                    hintStyle: TextStyle(color: AppTheme.nearlyDarkOrange ),
                    prefixIcon: Icon(Icons.search, color: AppTheme.nearlyDarkOrange),
                    enabledBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide:  BorderSide(color: AppTheme.nearlyDarkOrange ),

                  ),
                    focusedBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide:  BorderSide(color: AppTheme.nearlyDarkOrange ),

                  ),
                ),
              ),
            ),
            _items.length == 0
                ? Container(
                    margin: EdgeInsets.only(top: 200),
                    alignment: Alignment.center,
                    child: Text(
                      'No se encontraron solicitudes.',
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

                        return cardWidget(request: _items[index]);
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

        if (preferenceStorage.getValue(key: "requestLoad") == 'true') {
          setState(() {
            _items = Request.decode(
                preferenceStorage.getValue(key: "requests").toString());

            isLoading = false;
          });
          return;
        }
      }

      AuthenticationService auth = AuthenticationService();
      final User user = auth.getUserLogged();
      var items = await requestService.getRequest(idUsuario: user.id);

      if (items['OK']) {
        requestBloc.add(RequestLoad(load: true, requests: items['data']));
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

  Widget drawerBox(Request r) {
    Color color;
    if (r.estatusReclamacion == "Completada") {
      color = Colors.lightGreen;
    } else if (r.estatusReclamacion == "Asignada") {
      color = Colors.orangeAccent;
    } else if (r.estatusReclamacion == "Solicitada") {
      color = Colors.lightBlueAccent;
    }

    return Column(
      children: [
        Text('Estado'),
        SizedBox(height: 5),
        RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(
                  Icons.admin_panel_settings,
                  size: 22,
                  color: color,
                ),
              ),
              TextSpan(
                style: TextStyle(color: Colors.black),
                text: r.estatusReclamacion,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget cardWidget({Request request}) {
    String formattedDate = DateFormat.yMMMMd('es_PR')
        .format(DateTime.parse(request.fechaSolicitud));

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RequestDetails.routeName,
            arguments: request);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: 240.0,
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 22,
            child: Container(
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                Center(
                    child: FadeInImage.assetNetwork(
                      fit: BoxFit.fitWidth,
                      width: double.infinity,
                      placeholder: 'assets/gallery.png',
                      image: request.images[0],
                    ),
                  ),
                  Positioned(
                    top: 150,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: AppTheme.grey.withOpacity(0.2),
                              offset: Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      child: ListTile(
                          title: Text(request.tipoReclamacion,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          subtitle: Text(formattedDate),
                          trailing: drawerBox(request)),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      alignment: Alignment.center,
                      height: 20.0,
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(0.0),
                          gradient: new LinearGradient(colors: [
                            Color.fromARGB(255, 255, 136, 34),
                            Color.fromARGB(255, 255, 177, 41)
                          ])),
                      padding: const EdgeInsets.all(0),
                        child: Text(
                        "ID: #" + request.helpDeskId,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.white,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
