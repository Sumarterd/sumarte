// To parse this JSON data, do
//
//     final invoices = invoicesFromJson(jsonString);

import 'dart:convert';

Invoices invoicesFromJson(String str) => Invoices.fromJson(json.decode(str));

String invoicesToJson(Invoices data) => json.encode(data.toJson());

class Invoices {
  Invoices({
    this.id,
    this.name,
    this.lastname,
    this.type,
    this.nationality,
    this.documentType,
    this.documentNumber,
    this.status,
    this.defaultTaxReceiptType,
    this.address,
    this.phone,
    this.cellphone,
    this.invoices,
    this.amountDue,
  });

  String id;
  String name;
  String lastname;
  DefaultTaxReceiptType type;
  DefaultTaxReceiptType nationality;
  DefaultTaxReceiptType documentType;
  String documentNumber;
  int status;
  DefaultTaxReceiptType defaultTaxReceiptType;
  String address;
  dynamic phone;
  String cellphone;
  List<Invoice> invoices;
  double amountDue;

  factory Invoices.fromJson(Map<String, dynamic> json) => Invoices(
        id: json["id"],
        name: json["name"],
        lastname: json["lastname"],
        type: DefaultTaxReceiptType.fromJson(json["type"]),
        nationality: DefaultTaxReceiptType.fromJson(json["nationality"]),
        documentType: DefaultTaxReceiptType.fromJson(json["documentType"]),
        documentNumber: json["documentNumber"],
        status: json["status"],
        defaultTaxReceiptType:
            DefaultTaxReceiptType.fromJson(json["defaultTaxReceiptType"]),
        address: json["address"],
        phone: json["phone"],
        cellphone: json["cellphone"],
        invoices: List<Invoice>.from(
            json["invoices"].map((x) => Invoice.fromJson(x))),
        amountDue: double.tryParse(json["amountDue"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastname": lastname,
        "type": type.toJson(),
        "nationality": nationality.toJson(),
        "documentType": documentType.toJson(),
        "documentNumber": documentNumber,
        "status": status,
        "defaultTaxReceiptType": defaultTaxReceiptType.toJson(),
        "address": address,
        "phone": phone,
        "cellphone": cellphone,
        "invoices": List<dynamic>.from(invoices.map((x) => x.toJson())),
        "amountDue": amountDue,
      };
}

class DefaultTaxReceiptType {
  DefaultTaxReceiptType({
    this.id,
    this.description,
  });

  String id;
  String description;

  factory DefaultTaxReceiptType.fromJson(Map<String, dynamic> json) =>
      DefaultTaxReceiptType(
        id: json["id"],
        description: json["description"] == null ? null : json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description == null ? null : description,
      };
}

class Invoice {
  Invoice({
    this.id,
    this.date,
    this.description,
    this.address,
    this.taxReceiptType,
    this.number,
    this.total,
    this.status,
    this.receiptNumber,
    this.detail,
  });

  String id;
  String date;
  String description;
  String address;
  DefaultTaxReceiptType taxReceiptType;
  String number;
  double total;
  String status;
  dynamic receiptNumber;
  List<Detail> detail;

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        id: json["id"],
        date: json["date"],
        description: json["description"],
        address: json["address"],
        taxReceiptType: DefaultTaxReceiptType.fromJson(json["taxReceiptType"]),
        number: json["number"],
        total: json["total"],
        status: json["status"],
        receiptNumber: json["receiptNumber"],
        detail:
            List<Detail>.from(json["detail"].map((x) => Detail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "description": description,
        "address": address,
        "taxReceiptType": taxReceiptType.toJson(),
        "number": number,
        "total": total,
        "status": status,
        "receiptNumber": receiptNumber,
        "detail": List<dynamic>.from(detail.map((x) => x.toJson())),
      };
}

class Detail {
  Detail({
    this.line,
    this.tax,
    this.quantity,
    this.value,
    this.total,
  });

  String line;
  Tax tax;
  int quantity;
  double value;
  double total;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        line: json["line"],
        tax: Tax.fromJson(json["tax"]),
        quantity: json["quantity"],
        value: json["value"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "line": line,
        "tax": tax.toJson(),
        "quantity": quantity,
        "value": value,
        "total": total,
      };
}

class Tax {
  Tax({
    this.id,
    this.description,
    this.unit,
    this.value,
  });

  String id;
  String description;
  dynamic unit;
  int value;

  factory Tax.fromJson(Map<String, dynamic> json) => Tax(
        id: json["id"],
        description: json["description"],
        unit: json["unit"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "unit": unit,
        "value": value,
      };
}
