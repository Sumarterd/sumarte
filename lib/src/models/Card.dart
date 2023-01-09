// To parse this JSON data, do
//
//     final invoices = invoicesFromJson(jsonString);

import 'dart:convert';

Card profilesFromJson(String str) => Card.fromJson(json.decode(str));

class Card {
  Card({
    this.card,
    this.expire,
    this.cvv,
    this.amount,
    this.clientIp,
    this.currency,
    this.environment,
    this.idempotencyKey,
    this.invoiceNumber,
    this.merchantId,
    this.terminalId,
    this.referenceNumber,
    this.tax,
    this.tip,
    this.token
  });

  String card;
  String expire;
  String cvv;
  double amount;
  String clientIp;
  String currency;
  String environment;
  String idempotencyKey;
  String invoiceNumber;
  String merchantId;
  String terminalId;
  String referenceNumber;
  int tax;
  int tip;
  String token;

  factory Card.fromJson(Map<String, dynamic> json) => Card(
    card: json["card"],
    expire: json["expire"],
    cvv: json["cvv"],
    amount : json["amount"],
    clientIp : json["clientIp"],
    currency : json["currency"],
    environment : json["environment"],
    idempotencyKey : json["idempotencyKey"],
    invoiceNumber : json["invoiceNumber"],
    merchantId : json["merchantId"],
    terminalId : json["terminalId"],
    referenceNumber : json["referenceNumber"],
    tax : json["tax"],
    tip : json["tip"],
    token : json["token"]

  );

  Map<String, dynamic> toJson() => {
    "card": card,
    "expire": expire,
    "cvv": cvv,
    "amount" : amount,
    "clientIp" : clientIp,
    "currency" : currency,
    "environment" : environment,
    "idempotencyKey" : idempotencyKey,
    "invoiceNumber" : invoiceNumber,
    "merchantId" : merchantId,
    "terminalId" : terminalId,
    "referenceNumber" : referenceNumber,
    "tax" : tax,
    "tip" : tip,
    "token" : token
  };
}


MessageCard messageCardJson(String str) => MessageCard.fromJson(json.decode(str));

class MessageCard {
  MessageCard({
    this.id,
    this.codigo,
    this.descripcion,

  });

  String id;
  String codigo;
  String descripcion;

  factory MessageCard.fromJson(Map<String, dynamic> json) => MessageCard(
    id: json["id"],
    codigo: json["codigo"],
    descripcion: json["descripcion"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": codigo,
    "description": descripcion
  };
}