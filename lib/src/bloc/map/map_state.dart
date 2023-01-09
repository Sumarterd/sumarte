part of 'map_bloc.dart';

class MapState {
  final bool mapaReady;
  final LatLng ubicacionCentral;
  final bool existeUbicacion;
  final LatLng ubicacion;
  final bool scrollGesturesEnabled;
  final double mapaSize;
  final bool isOutOfRange;

  MapState({
    this.mapaReady = false,
    this.ubicacionCentral,
    this.existeUbicacion = false,
    this.ubicacion,
    this.scrollGesturesEnabled = true,
    this.mapaSize = 15.0,
    this.isOutOfRange = false,
  });

  MapState copyWith(
          {bool mapaReady,
          bool dibujarRecorrido,
          LatLng ubicacionCentral,
          bool existeUbicacion,
          LatLng ubicacion,
          bool scrollGesturesEnabled,
          double mapaSize,
          bool isOutOfRange}) =>
      new MapState(
          mapaReady: mapaReady ?? this.mapaReady,
          ubicacionCentral: ubicacionCentral ?? this.ubicacionCentral,
          existeUbicacion: existeUbicacion ?? this.existeUbicacion,
          scrollGesturesEnabled:
              scrollGesturesEnabled ?? this.scrollGesturesEnabled,
          ubicacion: ubicacion ?? this.ubicacion,
          mapaSize: mapaSize ?? this.mapaSize,
          isOutOfRange: isOutOfRange ?? this.isOutOfRange);
}
