// To parse this JSON data, do
//
//     final paymentIntentModel = paymentIntentModelFromJson(jsonString);

import 'dart:convert';

PaymentIntentModel paymentIntentModelFromJson(String str) =>
    PaymentIntentModel.fromJson(json.decode(str));

String paymentIntentModelToJson(PaymentIntentModel data) =>
    json.encode(data.toJson());

class PaymentIntentModel {
  PaymentIntentModel({
    required this.clientSecret,
  });

  String clientSecret;

  factory PaymentIntentModel.fromJson(Map<String, dynamic> json) =>
      PaymentIntentModel(
        clientSecret:
            json["clientSecret"] == null ? null : json["clientSecret"],
      );

  Map<String, dynamic> toJson() => {
        "clientSecret": clientSecret == null ? null : clientSecret,
      };
}
