import 'package:sumarte/src/pages/acceso_gps_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'helpers.dart';

Future<Map<String, dynamic>> checkGpsLocation({BuildContext context}) async {
  final permisoGps = await Permission.location.isGranted;
  final gpsActivo = await Geolocator.isLocationServiceEnabled();

  if (!permisoGps) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
          context, navegarFadeIn(context, AccesoGpsPage()));
    });
    return {"OK": false, "MSJ": "Dar permiso de GPS"};
  }
  if (!gpsActivo) {
    return {"OK": false, "MSJ": "Active el GPS"};
  }

  return {"OK": true, "MSJ": ""};
}
