// To parse this JSON data, do
//
//     final request = requestFromJson(jsonString);

import 'dart:convert';

List<Request> requestFromJson(String str) =>
    List<Request>.from(json.decode(str).map((x) => Request.fromJson(x)));

String requestToJson(List<Request> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Request {
  String reclamacionId;
  String helpDeskId;
  String descripcion;
  String fechaSolicitud;
  String fechaAsignacion;
  String fechaResolucion;
  String tipoReclamacion;
  String estatusReclamacion;
  String latitud;
  String longitud;
  String sector;
  String referenciaDireccion;
  List<String> images;

  Request(
      {this.reclamacionId,
      this.helpDeskId,
      this.descripcion,
      this.fechaSolicitud,
      this.fechaAsignacion,
      this.fechaResolucion,
      this.tipoReclamacion,
      this.estatusReclamacion,
      this.latitud,
      this.longitud,
      this.sector,
      this.referenciaDireccion,
      this.images});

  factory Request.fromJson(Map<String, dynamic> json) {
    List<String> images = [];
    for (var item in json['images']) {
      images.add(item);
    }
    return Request(
        reclamacionId: json["ReclamacionId"],
        helpDeskId: json["HelpDeskId"],
        descripcion: json["Descripcion"],
        // fechaSolicitud: DateTime.parse(json["FechaSolicitud"]),
        fechaSolicitud: json["FechaSolicitud"],
        fechaAsignacion: json["FechaAsignacion"],
        tipoReclamacion: json["TipoReclamacion"],
        estatusReclamacion: json["EstatusReclamacion"],
        latitud: json["Latitud"],
        longitud: json["Longitud"],
        sector: json["Sector"],
        referenciaDireccion: json["ReferenciaDireccion"],
        images: images);
  }

  Map<String, dynamic> toJson() => {
        "ReclamacionId": reclamacionId,
        "HelpDeskId": helpDeskId,
        "Descripcion": descripcion,
        "FechaSolicitud": fechaSolicitud,
        "TipoReclamacion": tipoReclamacion,
        "EstatusReclamacion": estatusReclamacion,
        "Latitud": latitud,
        "Longitud": longitud,
        "Sector": sector,
        "ReferenciaDireccion": referenciaDireccion,
      };

  static Map<String, dynamic> toMap(Request request) => {
        "ReclamacionId": request.reclamacionId,
        "HelpDeskId": request.helpDeskId,
        "Descripcion": request.descripcion,
        "FechaSolicitud": request.fechaSolicitud,
        "TipoReclamacion": request.tipoReclamacion,
        "EstatusReclamacion": request.estatusReclamacion,
        "Latitud": request.latitud,
        "Longitud": request.longitud,
        "Sector": request.sector,
        "ReferenciaDireccion": request.referenciaDireccion,
        "images": request.images
      };
  static String encode(List<Request> requests) => json.encode(
        requests
            .map<Map<String, dynamic>>((request) => Request.toMap(request))
            .toList(),
      );

  static List<Request> decode(String requests) {
    List<Request> list = [];
    final req = json.decode(requests);
    for (var item in req) {
      final r = Request.fromJson(item);
      if (r != null) {
        list.add(r);
      }
    }
    return list;
  }
}
