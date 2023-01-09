import 'dart:convert';
import 'Contracts.dart';

UserTransneg userTransnegFromJson(String str) =>
    UserTransneg.fromJson(json.decode(str));

String userTransnegToJson(UserTransneg data) => json.encode(data.toJson());

class UserTransneg {
  UserTransneg({
    this.codigoRespuesta,
    this.descripcionRespuesta,
    this.nombrePuntoVenta,
    this.nombreTitular,
    this.direccionServicio,
    this.cantidadContratosAsociados,
    this.contratosAsociados,
    this.idContribuyente,
    this.tipo,
    this.nacionalidad,
    this.tipoDocumento,
    this.numeroDocumento,
    this.estado,
    this.telefono,
    this.celular,
    this.montoAdeudado,
    this.montoAdeudadoC,
  });

  String codigoRespuesta;
  String descripcionRespuesta;
  String nombrePuntoVenta;
  String nombreTitular;
  String direccionServicio;
  int cantidadContratosAsociados;
  List<Contracts> contratosAsociados;
  int idContribuyente;
  String tipo;
  String nacionalidad;
  String tipoDocumento;
  String numeroDocumento;
  String estado;
  String telefono;
  String celular;
  double montoAdeudado;
  int montoAdeudadoC;

  factory UserTransneg.fromJson(Map<String, dynamic> json) => UserTransneg(
      codigoRespuesta: json["codigoRespuesta"],
      descripcionRespuesta: json["descripcionRespuesta"],
      nombrePuntoVenta: json["nombrePuntoVenta"],
      nombreTitular: json["nombreTitular"],
      direccionServicio: json["direccionServicio"],
      cantidadContratosAsociados: json["cantidadContratosAsociados"],
      contratosAsociados: List<Contracts>.from(
          json["contratosAsociados"].map((x) => Contracts.fromJson(x))),
      idContribuyente: json["idContribuyente"],
      tipo: json["tipo"],
      nacionalidad: json["nacionalidad"],
      tipoDocumento: json["tipoDocumento"],
      numeroDocumento: json["numeroDocumento"],
      estado: json["estado"],
      telefono: json["telefono"],
      celular: json["celular"],
      montoAdeudado: (json["montoAdeudado"] == 0)
          ? json["montoAdeudado"] = 0.0
          : json["montoAdeudado"],
      montoAdeudadoC: json["montoAdeudadoC"]);

  Map<String, dynamic> toJson() => {
        "codigoRespuesta": codigoRespuesta,
        "descripcionRespuesta": descripcionRespuesta,
        "nombrePuntoVenta": nombrePuntoVenta,
        "nombreTitular": nombreTitular,
        "direccionServicio": direccionServicio,
        "cantidadContratosAsociados": cantidadContratosAsociados,
        "contratosAsociados":
            List<dynamic>.from(contratosAsociados.map((x) => x.toJson())),
        "idContribuyente": idContribuyente,
        "tipo": tipo,
        "nacionalidad": nacionalidad,
        "tipoDocumento": tipoDocumento,
        "numeroDocumento": numeroDocumento,
        "estado": estado,
        "telefono": telefono,
        "celular": celular,
        "montoAdeudado": montoAdeudado,
        "montoAdeudadoC": montoAdeudadoC
      };
  static Map<String, dynamic> toMap(UserTransneg invoice) => {
    "codigoRespuesta": invoice.codigoRespuesta,
    "descripcionRespuesta": invoice.descripcionRespuesta,
    "nombrePuntoVenta": invoice.nombrePuntoVenta,
    "nombreTitular": invoice.nombreTitular,
    "direccionServicio": invoice.direccionServicio,
    "cantidadContratosAsociados": invoice.cantidadContratosAsociados,
    "contratosAsociados":
    List<dynamic>.from(invoice.contratosAsociados.map((x) => x.toJson())),
    "idContribuyente": invoice.idContribuyente,
    "tipo": invoice.tipo,
    "nacionalidad": invoice.nacionalidad,
    "tipoDocumento": invoice.tipoDocumento,
    "numeroDocumento": invoice.numeroDocumento,
    "estado": invoice.estado,
    "telefono": invoice.telefono,
    "celular": invoice.celular,
    "montoAdeudado": invoice.montoAdeudado,
    "montoAdeudadoC": invoice.montoAdeudadoC
  };
  static String encode(UserTransneg invoice) => json.encode(
    UserTransneg.toMap(invoice)
  );
  static  UserTransneg decode(String invoice) {
    return UserTransneg.fromJson(json.decode(invoice));
  }
}
