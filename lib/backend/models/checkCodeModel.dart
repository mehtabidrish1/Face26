import 'dart:convert';

CheckCodeModel checkCodeModelFromJson(String str) =>
    CheckCodeModel.fromJson(json.decode(str));

String checkCodeModelToJson(CheckCodeModel data) => json.encode(data.toJson());

class CheckCodeModel {
  CheckCodeModel({
    this.accessToken,
  });

  String? accessToken;

  factory CheckCodeModel.fromJson(Map<String, dynamic> json) => CheckCodeModel(
        accessToken: json["access_token"] == null ? null : json["access_token"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken == null ? null : accessToken,
      };
}
