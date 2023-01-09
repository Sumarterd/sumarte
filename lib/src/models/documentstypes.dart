// To parse this JSON data, do
//
//     final documentsTypes = documentsTypesFromJson(jsonString);

import 'dart:convert';

DocumentsTypes documentsTypesFromJson(String str) =>
    DocumentsTypes.fromJson(json.decode(str));

String documentsTypesToJson(DocumentsTypes data) => json.encode(data.toJson());

class DocumentsTypes {
  DocumentsTypes({
    this.status,
    this.data,
  });

  bool status;
  List<DocumentType> data;

  factory DocumentsTypes.fromJson(Map<String, dynamic> json) => DocumentsTypes(
        status: json["status"],
        data: List<DocumentType>.from(
            json["data"].map((x) => DocumentType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DocumentType {
  DocumentType({
    this.idTipoDocumento,
    this.descripcionDocumento,
    this.isMovilDocument,
  });

  String idTipoDocumento;
  String descripcionDocumento;
  String isMovilDocument;

  factory DocumentType.fromJson(Map<String, dynamic> json) => DocumentType(
        idTipoDocumento: json["IdTipoDocumento"],
        descripcionDocumento: json["DescripcionDocumento"],
        isMovilDocument: json["IsMovilDocument"],
      );

  Map<String, dynamic> toJson() => {
        "IdTipoDocumento": idTipoDocumento,
        "DescripcionDocumento": descripcionDocumento,
        "IsMovilDocument": isMovilDocument,
      };
}
