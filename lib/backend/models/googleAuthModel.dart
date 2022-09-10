// To parse this JSON data, do
//
//     final googleAuthModel = googleAuthModelFromJson(jsonString);

import 'dart:convert';

GoogleAuthModel googleAuthModelFromJson(String str) =>
    GoogleAuthModel.fromJson(json.decode(str));

String googleAuthModelToJson(GoogleAuthModel data) =>
    json.encode(data.toJson());

class GoogleAuthModel {
  GoogleAuthModel({
    required this.accessToken,
    this.authType,
    required this.email,
  });

  String accessToken;
  String? authType;
  String email;

  factory GoogleAuthModel.fromJson(Map<String, dynamic> json) =>
      GoogleAuthModel(
        accessToken: json["access_token"] == null ? null : json["access_token"],
        authType: json["auth_type"] == null ? null : json["auth_type"],
        email: json["email"] == null ? null : json["email"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken == null ? null : accessToken,
        "auth_type": authType == null ? null : authType,
        "email": email == null ? null : email,
      };
}
