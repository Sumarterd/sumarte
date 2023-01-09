import 'dart:convert';
import 'package:sumarte/src/models/Invoices.dart';
import 'InvoiceTransneg.dart';

Contracts contractsFromJson(String str) => Contracts.fromJson(json.decode(str));
String contractsToJson(Invoices data) => json.encode(data.toJson());

class Contracts{
  Contracts({
  this.codigoRespuesta,
  this.descripcionRespuesta,
  this.nombrePuntoVenta,
  this.numeroContrato,
  this.nombreTitular,
  this.direccionServicio,
  this.montoTotal,
  this.montoSubsidio,
  this.montoExcedente,
  this.esClienteSubsidiado,
  this.facturas,
  this.facturasBillFast,
  this.contratosBase,
  this.documentoFecha,
  this.numeroDocumento
});
    String codigoRespuesta;
    String descripcionRespuesta;
    String nombrePuntoVenta;
    String numeroContrato;
    String nombreTitular;
    String direccionServicio;
    double montoTotal;
    int montoSubsidio;
    int montoExcedente;
    bool esClienteSubsidiado;
    List<InvoiceTransneg> facturas;
    String facturasBillFast;
    String contratosBase;
  String documentoFecha;
    String numeroDocumento;

  factory Contracts.fromJson(Map<String, dynamic> json) => Contracts(
      codigoRespuesta: json["codigoRespuesta"],
      descripcionRespuesta: json["descripcionRespuesta"],
      nombrePuntoVenta: json["nombrePuntoVenta"],
      numeroContrato: json["numeroContrato"],
      nombreTitular: json["nombreTitular"],
      direccionServicio: json["direccionServicio"],
      montoTotal: json["montoTotal"],
      montoSubsidio: json["montoSubsidio"],
      montoExcedente: json["montoExcedente"],
      esClienteSubsidiado: json["esClienteSubsidiado"],
      facturas: List<InvoiceTransneg>.from(json["facturas"].map((x) => InvoiceTransneg.fromJson(x))),
      facturasBillFast: json["facturasBillFast"],
      contratosBase: json["contratosBase"],
      documentoFecha: json["documentoFecha"],
      numeroDocumento: json["numeroDocumento"],
  );

  Map<String, dynamic> toJson() => {
    "codigoRespuesta": codigoRespuesta,
    "descripcionRespuesta": descripcionRespuesta,
    "nombrePuntoVenta": nombrePuntoVenta,
    "numeroContrato": numeroContrato,
    "nombreTitular": nombreTitular,
    "direccionServicio": direccionServicio,
    "montoTotal": montoTotal,
    "montoSubsidio":  montoSubsidio,
    "montoExcedente": montoExcedente,
    "esClienteSubsidiado": esClienteSubsidiado,
    "facturas": List<dynamic>.from(facturas.map((x) => x.toJson())),
    "facturasBillFast": facturasBillFast,
    "contratosBase":  contratosBase,
    "documentoFecha":  documentoFecha,
    "numeroDocumento":  numeroDocumento,
  };

}