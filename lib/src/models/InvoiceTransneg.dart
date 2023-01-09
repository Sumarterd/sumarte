import 'dart:convert';

InvoiceTransneg invoicesFromJson(String str) => InvoiceTransneg.fromJson(json.decode(str));
String invoicesToJson(InvoiceTransneg data) => json.encode(data.toJson());

class InvoiceTransneg{

  InvoiceTransneg({
    this.idFactura,
    this.fechaEmision,
    this.fechaVencimiento,
    this.montoAdeudado,
    this.montoSubsidio,
    this.montoExcedente,
    this.descripcion
});
  String idFactura;
  String fechaEmision;
  String fechaVencimiento;
  double montoAdeudado;
  int montoSubsidio;
  int montoExcedente;
  String descripcion;

  factory InvoiceTransneg.fromJson(Map<String, dynamic> json) => InvoiceTransneg(
    idFactura: json["idFactura"],
    fechaEmision: json["fechaEmision"],
    fechaVencimiento: json["fechaVencimiento"],
    montoAdeudado: json["montoAdeudado"],
    montoSubsidio:  json["montoSubsidio"],
    montoExcedente: json["montoExcedente"],
    descripcion: json["descripcion"]
  );

  Map<String, dynamic> toJson() => {
    "idFactura": idFactura,
    "fechaEmision": fechaEmision,
    "fechaVencimiento": fechaVencimiento,
    "montoAdeudado": montoAdeudado,
    "montoSubsidio": montoSubsidio,
    "montoExcedente": montoExcedente,
    "descripcion": descripcion
  };
}