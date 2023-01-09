import 'package:sumarte/src/helpers/helpers.dart';
import 'package:sumarte/src/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:permission_handler/permission_handler.dart';

import 'loading_page.dart';

class AccesoGpsPage extends StatefulWidget {
  static final routeName = '/acceso_gps';
  const AccesoGpsPage({Key key}) : super(key: key);

  @override
  _AccesoGpsPageState createState() => _AccesoGpsPageState();
}

class _AccesoGpsPageState extends State<AccesoGpsPage>
    with WidgetsBindingObserver {
  bool _isButtonDisabled;
  @override
  void initState() {
    _isButtonDisabled = false;
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      _isButtonDisabled = false;
      if (await Permission.location.isGranted) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, LoadingPage.routeName);
        });
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: Image(
                width: 200,
                image: AssetImage('assets/logo_paqueno.png'),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Es necesario que active el GPS',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                MaterialButton(
                  shape: StadiumBorder(),
                  elevation: 0,
                  splashColor: Colors.transparent,
                  onPressed: () async {
                    if (!_isButtonDisabled) {
                      _isButtonDisabled = true;
                      final status = await Permission.location.request();
                      this.accesoGPS(context: context, status: status);
                    }
                  },
                  color: Constants.orangeDark,
                  child: Text('Solicitar Acceso',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void accesoGPS({BuildContext context, PermissionStatus status}) {
    switch (status) {
      case PermissionStatus.granted:
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, LoginPage.routeName);
        });
        break;

      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
        break;
      case PermissionStatus.limited:
        break;
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
