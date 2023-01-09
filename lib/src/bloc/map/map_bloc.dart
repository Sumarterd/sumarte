import 'dart:async';
import 'dart:convert';

import 'package:sumarte/src/themes/uber_map_theme.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc({MapState initialState}) : super(initialState);
  StreamSubscription<Position> _positionSubcription;
  //Controlador del mapa
  GoogleMapController _mapController;
  //Controlador del mapa
  void iniciarSeguimiento() {
    _positionSubcription = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.high, distanceFilter: 10)
        .listen((Position position) {
      final newLocation = new LatLng(position.latitude, position.longitude);
      add(OnChangeLocation(newLocation));
    });
  }

  get mapController => _mapController;

  void cancelarSeguimiento() {
    _positionSubcription?.cancel();
  }

  void initMap(GoogleMapController controller) {
    if (!state.mapaReady) {
      this._mapController = controller;
      // Cambiar estilo del mapa
      _mapController.setMapStyle(jsonEncode(uberMapTheme));

      add(OnMapReady());
    }
  }

  void moveCamera(LatLng destino) {
    final cameraUpdate = CameraUpdate.newLatLng(destino);
    this._mapController?.animateCamera(cameraUpdate);
  }

  @override
  Stream<MapState> mapEventToState(
    MapEvent event,
  ) async* {
    //ubicacionCentral
    if (event is OnMapReady) {
      yield state.copyWith(mapaReady: true);
    } else if (event is OnChangeLocation) {
      yield state.copyWith(
          existeUbicacion: true,
          ubicacion: event.ubicacion,
          ubicacionCentral: event.ubicacion);
    } else if (event is OnMoveMap) {
      yield state.copyWith(ubicacionCentral: event.centroMapa);
    } else if (event is OnStartMap) {
      yield state.copyWith(scrollGesturesEnabled: true);
    } else if (event is OnStopMap) {
      yield state.copyWith(scrollGesturesEnabled: false);
    } else if (event is OnExitMap) {
      yield state.copyWith(mapaReady: false);
    } else if (event is OnPlusMap) {
      yield state.copyWith(mapaSize: state.mapaSize + 1.0);
    } else if (event is OutOfRange) {
      yield state.copyWith(isOutOfRange: event.fueraRango);
    }
  }

  Future<bool> checkIfWithinBounds(LatLng yourLocation) async {
    var mapBounds = await mapController.getVisibleRegion();
    return mapBounds.contains(
      LatLng(yourLocation.latitude, yourLocation.longitude),
    );
  }
}
