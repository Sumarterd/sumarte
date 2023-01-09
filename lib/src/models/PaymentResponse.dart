import 'dart:convert';

PaymentResponse paymentResponseFromJson(String str) =>
    PaymentResponse.fromJson(json.decode(str));

String paymentResponseToJson(PaymentResponse data) =>
    json.encode(data.toJson());

class PaymentResponse {
  PaymentResponse(
      {this.codigoRespuesta,
      this.descripcionRespuesta });

  String codigoRespuesta;
  String descripcionRespuesta;


  factory PaymentResponse.fromJson(Map<String, dynamic> json) =>
      PaymentResponse(
          codigoRespuesta: json["codigoRespuesta"],
          descripcionRespuesta: json["descripcionRespuesta"]
      );

  Map<String, dynamic> toJson() => {
        "codigoRespuesta": codigoRespuesta,
        "descripcionRespuesta": descripcionRespuesta
      };
}
