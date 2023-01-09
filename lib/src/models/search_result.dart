import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class SearchResult {
  final bool canceled;
  final bool manualUbication;
  final LatLng positionDestination;
  final String nombreDestino;
  final String description;
  final bool scrollGesturesEnabled;

  SearchResult(
      {@required this.canceled,
      this.manualUbication,
      this.positionDestination,
      this.nombreDestino,
      this.description,
      this.scrollGesturesEnabled});

  SearchResult copyWith(
          {bool canceled,
          bool manualUbication,
          LatLng positionDestination,
          String nombreDestino,
          String description,
          bool scrollGesturesEnabled}) =>
      new SearchResult(
          canceled: canceled ?? this.canceled,
          manualUbication: manualUbication ?? this.manualUbication,
          positionDestination: positionDestination ?? this.positionDestination,
          nombreDestino: nombreDestino ?? this.nombreDestino,
          scrollGesturesEnabled:
              scrollGesturesEnabled ?? this.scrollGesturesEnabled,
          description: description ?? this.description);
}
