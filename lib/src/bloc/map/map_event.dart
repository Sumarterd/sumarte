part of 'map_bloc.dart';

@immutable
abstract class MapEvent {}

class OnMapReady extends MapEvent {}

class OnLocationUpdate extends MapEvent {
  final LatLng ubicacion;
  OnLocationUpdate(this.ubicacion);
}

class OnMoveMap extends MapEvent {
  final LatLng centroMapa;
  OnMoveMap(this.centroMapa);
}

class OutOfRange extends MapEvent {
  final bool fueraRango;
  OutOfRange(this.fueraRango);
}

class OnChangeLocation extends MapEvent {
  final LatLng ubicacion;
  OnChangeLocation(this.ubicacion);
}

class OnCreateRouteBeginEnd extends MapEvent {
  final List<LatLng> rutaCoordenadas;
  final double distancia;
  final double duracion;
  final String nombreDestino;

  OnCreateRouteBeginEnd(
      {this.rutaCoordenadas,
      this.distancia,
      this.duracion,
      this.nombreDestino});
}

class OnStartMap extends MapEvent {}

class OnStopMap extends MapEvent {}

class OnExitMap extends MapEvent {}

class OnPlusMap extends MapEvent {}

class OnMinusMap extends MapEvent {}
