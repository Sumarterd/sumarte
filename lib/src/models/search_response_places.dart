// To parse this JSON data, do
//
//     final searchResponsePlaces = searchResponsePlacesFromJson(jsonString);

import 'dart:convert';

SearchResponsePlaces searchResponsePlacesFromJson(String str) =>
    SearchResponsePlaces.fromJson(json.decode(str));

String searchResponsePlacesToJson(SearchResponsePlaces data) =>
    json.encode(data.toJson());

class SearchResponsePlaces {
  SearchResponsePlaces({
    this.htmlAttributions,
    this.results,
    this.status,
  });

  List<dynamic> htmlAttributions;
  List<Result> results;
  String status;

  factory SearchResponsePlaces.fromJson(Map<String, dynamic> json) =>
      SearchResponsePlaces(
        htmlAttributions:
            List<dynamic>.from(json["html_attributions"].map((x) => x)),
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "html_attributions": List<dynamic>.from(htmlAttributions.map((x) => x)),
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "status": status,
      };
}

class Result {
  Result({
    this.formattedAddress,
    this.geometry,
    this.icon,
    this.name,
    this.placeId,
    this.reference,
    this.types,
  });

  String formattedAddress;
  Geometry geometry;
  String icon;
  String name;
  String placeId;
  String reference;
  List<String> types;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        formattedAddress: json["formatted_address"],
        geometry: Geometry.fromJson(json["geometry"]),
        icon: json["icon"],
        name: json["name"],
        placeId: json["place_id"],
        reference: json["reference"],
        types: List<String>.from(json["types"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "formatted_address": formattedAddress,
        "geometry": geometry.toJson(),
        "icon": icon,
        "name": name,
        "place_id": placeId,
        "reference": reference,
        "types": List<dynamic>.from(types.map((x) => x)),
      };
}

class Geometry {
  Geometry({
    this.location,
    this.viewport,
  });

  Location location;
  Viewport viewport;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: Location.fromJson(json["location"]),
        viewport: Viewport.fromJson(json["viewport"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "viewport": viewport.toJson(),
      };
}

class Location {
  Location({
    this.lat,
    this.lng,
  });

  double lat;
  double lng;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

class Viewport {
  Viewport({
    this.northeast,
    this.southwest,
  });

  Location northeast;
  Location southwest;

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
        northeast: Location.fromJson(json["northeast"]),
        southwest: Location.fromJson(json["southwest"]),
      );

  Map<String, dynamic> toJson() => {
        "northeast": northeast.toJson(),
        "southwest": southwest.toJson(),
      };
}
