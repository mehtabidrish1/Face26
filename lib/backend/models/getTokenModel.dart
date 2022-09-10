import 'dart:convert';

GetTokenModel getTokenModelFromJson(String str) =>
    GetTokenModel.fromJson(json.decode(str));

String getTokenModelToJson(GetTokenModel data) => json.encode(data.toJson());

class GetTokenModel {
  GetTokenModel({
    this.accessToken = '',
  });

  String accessToken;

  factory GetTokenModel.fromJson(Map<String, dynamic> json) => GetTokenModel(
        accessToken: json["access_token"] == null ? null : json["access_token"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken == null ? null : accessToken,
      };
}
