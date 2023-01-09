import 'package:sumarte/src/config/app_theme.dart';
import 'package:sumarte/src/config/main_full_view.dart';
import 'package:sumarte/src/models/Request.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class RequestDetails extends StatefulWidget {
  static final routeName = '/requestdetail';

  const RequestDetails({Key key}) : super(key: key);

  @override
  _RequestDetailsState createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetails>  with TickerProviderStateMixin{

  DateTime drawerDate(Request r) {
    DateTime fecha;

    if (r.fechaResolucion != null) {
      fecha = DateTime.parse(r.fechaResolucion);
    } else if (r.fechaAsignacion != null) {
      fecha = DateTime.parse(r.fechaAsignacion);
    } else if (r.fechaSolicitud != null) {
      fecha = DateTime.parse(r.fechaSolicitud);
    }
  return fecha;
  }

  final double infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    super.initState();
  }

  Future<void> setData() async {
    animationController?.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context).settings.arguments as Request;
    Color color;
    if (args.estatusReclamacion == "Completada") {
      color = Colors.lightGreen;
    } else if (args.estatusReclamacion == "Asignada") {
      color = Colors.orangeAccent;
    } else if (args.estatusReclamacion == "Solicitada") {
      color = Colors.lightBlueAccent;
    }
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0;
    return Container(
      color: AppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.2,
                  child: Swiper(
                    autoplay: true,
                    itemBuilder: (BuildContext context, int index) {
                      return FadeInImage.assetNetwork(
                        fit: BoxFit.fitWidth,
                        placeholder: 'assets/gallery.png',
                        image: args.images[index],
                      );
                    },
                    itemCount: args.images.length,
                    pagination: SwiperPagination(),
                    control: SwiperControl(),
                  ),
                ),
              ],
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 64.0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.nearlyWhite,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32.0),
                      topRight: Radius.circular(32.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: AppTheme.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                          minHeight: infoHeight,
                          maxHeight: tempHeight > infoHeight
                              ? tempHeight
                              : infoHeight),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 32.0, left: 18, right: 16),
                            child: Text(
                              args.sector.toString(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                letterSpacing: 0.27,
                                color: AppTheme.darkerText,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 8, top: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  args.tipoReclamacion.toString(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 18,
                                    letterSpacing: 0.27,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                 /*     Text(
                                        '#5453',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 22,
                                          letterSpacing: 0.27,
                                          color: AppTheme.grey,
                                        ),
                                      ),*/
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity1,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: <Widget>[
                                  getTimeBoxUI('Estado',args.estatusReclamacion,color),
                                  getTimeBoxUI('Fecha', DateFormat.yMMMMd('es_PR').format(drawerDate(args)), AppTheme.orange),
                                  //getTimeBoxUI('24', 'Seat'),
                                ],
                              ),
                            ),
                          ),

                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity1,
                           child: Padding(
                          padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                    child: Text(
                      'Descripción',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                        letterSpacing: 0.27,
                        color: AppTheme.orange,
                      ),
                    ),
                  ),
                          ),

                          Expanded(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: opacity2,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 8, bottom: 8),
                                child: Text(
                                  args.descripcion.toString(),
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                    letterSpacing: 0.27,
                                    color: AppTheme.grey,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 6, right: 16, top: 8, bottom: 8),
                                          child: Text(
                                            'Ubicación',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 18,
                                              letterSpacing: 0.27,
                                              color: AppTheme.orange,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    child: GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                          target: LatLng(double.tryParse(args.latitud),
                                              double.tryParse(args.longitud)),
                                          zoom: 15),
                                      zoomControlsEnabled: true,
                                      markers: <Marker>[
                                        Marker(
                                          markerId: MarkerId("1"),
                                          position: LatLng(double.tryParse(args.latitud),
                                              double.tryParse(args.longitud)),
                                        )
                                      ].toSet(),
                                      zoomGesturesEnabled: false,
                                      scrollGesturesEnabled: false,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity3,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, bottom: 16, right: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 48,
                                    height: 48,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppTheme.nearlyWhite,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(16.0),
                                        ),
                                        border: Border.all(
                                            color: AppTheme.grey
                                                .withOpacity(0.2)),
                                      ),
                                      child: InkWell(
                                        borderRadius:
                                        BorderRadius.circular(AppBar().preferredSize.height),
                                        child: Icon(
                                          Icons.arrow_back_ios_new_sharp,
                                          color: AppTheme.orange,
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),

                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {   Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MainFullViewer(
                                                  identificationPage: "CreateRequest")));},
                                      child: Container(
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: AppTheme.nearlyOrgane,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(16.0),
                                        ),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: AppTheme
                                                  .nearlyOrgane
                                                  .withOpacity(0.5),
                                              offset: const Offset(1.1, 1.1),
                                              blurRadius: 10.0),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Crear nueva solicitud',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            letterSpacing: 0.0,
                                            color: AppTheme
                                                .nearlyWhite,
                                          ),
                                        ),
                                      ),
                                    ),),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 24.0 - 95,
              right: 5,
              child: ScaleTransition(
                alignment: Alignment.center,
                scale: CurvedAnimation(
                    parent: animationController, curve: Curves.fastOutSlowIn),
                child: Card(
                  color: AppTheme.nearlyOrgane,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                  elevation: 10.0,
                  child: Container(
                    width: 80,
                    height: 80,
                    child: Center(
                      child: Text(
                        '#' + args.helpDeskId,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          letterSpacing: 0.27,
                          color: AppTheme.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getTimeBoxUI(String text1, String txt2, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color:  AppTheme.nearlyWhite,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: AppTheme.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 8.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                text1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: AppTheme.nearlyOrgane,
                ),
              ),
              Text(
                txt2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
