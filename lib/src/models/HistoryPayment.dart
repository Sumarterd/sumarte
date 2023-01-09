// To parse this JSON data, do
//
//     final invoices = invoicesFromJson(jsonString);

import 'dart:convert';

List<HistoryPayment> requestFromJson(String str) => List<HistoryPayment>.from(
    json.decode(str).map((x) => HistoryPayment.fromJson(x)));

String requestToJson(List<HistoryPayment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HistoryPayment {
  String id;
  String user_name;
  String card_number;
  String amount;
  String invoice_number;
  String reference_number;
  String approval_code;
  String date_created;

  HistoryPayment(
      {this.id,
      this.user_name,
      this.card_number,
      this.amount,
      this.invoice_number,
      this.reference_number,
      this.approval_code,
      this.date_created});

  factory HistoryPayment.fromJson(Map<String, dynamic> json) {

    return HistoryPayment(
        id: json["id"],
        user_name: json["user_name"],
        card_number: json["card_number"],
        amount: json["amount"],
        invoice_number: json["invoice_number"],
        reference_number: json["reference_number"],
        approval_code: json["approval_code"],
        date_created: json["date_created"],
      );
  }
  Map<String, dynamic> toJson() => {
        "user_name": user_name,
        "card_number": card_number,
        "amount": amount,
        "invoice_number": invoice_number,
        "reference_number": reference_number,
        "approval_code": approval_code,
        "date_created": date_created
      };

  static Map<String, dynamic> toMap(HistoryPayment historyPayment) => {
        "user_name": historyPayment.user_name,
        "card_number": historyPayment.card_number,
        "amount": historyPayment.amount,
        "invoice_number": historyPayment.invoice_number,
        "reference_number": historyPayment.reference_number,
        "approval_code": historyPayment.approval_code,
        "date_created": historyPayment.date_created
      };

  static String encode(List<HistoryPayment> paymentHistory) => json.encode(
        paymentHistory
            .map<Map<String, dynamic>>(
                (paymentHistory) => HistoryPayment.toMap(paymentHistory))
            .toList(),
      );

  static List<HistoryPayment> decode(String paymentHistory) {
    List<HistoryPayment> list = [];
    final hp = json.decode(paymentHistory);
    for (var item in hp) {
      var r = HistoryPayment.fromJson(item);
      if (r != null) {
        list.add(r);
      }
    }
    return list;
  }
}
