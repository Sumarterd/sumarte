// To parse this JSON data, do
//
//     final invoices = invoicesFromJson(jsonString);

import 'dart:convert';

Profile profilesFromJson(String str) => Profile.fromJson(json.decode(str));

class Profile {
  Profile({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.phone,
    this.identificationCard,
  });

  String id;
  String firstName;
  String lastName;
  String email;
  String password;
  String phone;
  String identificationCard;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    password: json['password'],
    email: json["email"],
    phone: json["phone"],
    identificationCard: json["IdentificationCard"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "password": password,
    "email": email,
    "phone": phone,
    "IdentificationCard": identificationCard,
  };
}


