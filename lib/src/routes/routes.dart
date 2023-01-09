import 'package:sumarte/src/config/main_full_view.dart';
import 'package:sumarte/src/pages/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:sumarte/src/pages/mapa_page.dart';
import 'package:sumarte/src/pages/request_details.dart';
import 'package:sumarte/src/pages/acceso_gps_page.dart';
import 'package:sumarte/src/pages/loading_page.dart';
import 'package:sumarte/src/pages/register_page.dart';
import 'package:sumarte/src/pages/login_page.dart';

Map<String, WidgetBuilder> getApplicationsRoutes() {
  return <String, WidgetBuilder>{
    LoginPage.routeName: (BuildContext context) => LoginPage(),
    MainFullViewer.routeName: (BuildContext context) =>
        MainFullViewer(identificationPage: "home"),
    LoadingPage.routeName: (BuildContext context) => LoadingPage(),
    RegisterPage.routeName: (BuildContext context) => RegisterPage(),
    AccesoGpsPage.routeName: (BuildContext context) => AccesoGpsPage(),
    MapaPage.routeName: (BuildContext context) => MapaPage(),
    RequestDetails.routeName: (BuildContext context) => RequestDetails(),
    ResetPassword.routeName: (BuildContext context) => ResetPassword(),
  };
}
