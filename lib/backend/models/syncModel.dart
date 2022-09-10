// To parse this JSON data, do
//
//     final syncModel = syncModelFromJson(jsonString);

import 'dart:convert';

SyncModel syncModelFromJson(String str) => SyncModel.fromJson(json.decode(str));

String syncModelToJson(SyncModel data) => json.encode(data.toJson());

class SyncModel {
  SyncModel({
    this.payments,
    this.photos,
    this.user,
  });

  List<dynamic>? payments;
  List<Photo>? photos;
  User? user;

  factory SyncModel.fromJson(Map<String, dynamic> json) => SyncModel(
        payments: json["payments"] == null
            ? null
            : List<dynamic>.from(json["payments"].map((x) => x)),
        photos: json["photos"] == null
            ? null
            : List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "payments": payments == null
            ? null
            : List<dynamic>.from(payments!.map((x) => x)),
        "photos": photos == null
            ? null
            : List<dynamic>.from(photos!.map((x) => x.toJson())),
        "user": user == null ? null : user!.toJson(),
      };
}

class Photo {
  Photo({
    this.id,
    this.purchased,
    this.timestampCreated,
  });

  Id? id;
  bool? purchased;
  TimestampCreated? timestampCreated;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        id: json["_id"] == null ? null : Id.fromJson(json["_id"]),
        purchased: json["purchased"] == null ? null : json["purchased"],
        timestampCreated: json["timestamp_created"] == null
            ? null
            : TimestampCreated.fromJson(json["timestamp_created"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id!.toJson(),
        "purchased": purchased == null ? null : purchased,
        "timestamp_created":
            timestampCreated == null ? null : timestampCreated!.toJson(),
      };
}

class Id {
  Id({
    this.oid,
  });

  String? oid;

  factory Id.fromJson(Map<String, dynamic> json) => Id(
        oid: json["\u0024oid"] == null ? null : json["\u0024oid"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024oid": oid == null ? null : oid,
      };
}

class TimestampCreated {
  TimestampCreated({
    this.date,
  });

  DateTime? date;

  factory TimestampCreated.fromJson(Map<String, dynamic> json) =>
      TimestampCreated(
        date: json["\u0024date"] == null
            ? null
            : DateTime.parse(json["\u0024date"]),
      );

  Map<String, dynamic> toJson() => {
        "\u0024date": date == null ? null : date!.toIso8601String(),
      };
}

class User {
  User({
    this.id,
    this.credits,
    this.dialogs,
    this.email,
  });

  Id? id;
  int? credits;
  Dialogs? dialogs;
  String? email;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"] == null ? null : Id.fromJson(json["_id"]),
        credits: json["credits"] == null ? null : json["credits"],
        dialogs:
            json["dialogs"] == null ? null : Dialogs.fromJson(json["dialogs"]),
        email: json["email"] == null ? null : json["email"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id!.toJson(),
        "credits": credits == null ? null : credits,
        "dialogs": dialogs == null ? null : dialogs!.toJson(),
        "email": email == null ? null : email,
      };
}

class Dialogs {
  Dialogs({
    this.welcome,
  });

  bool? welcome;

  factory Dialogs.fromJson(Map<String, dynamic> json) => Dialogs(
        welcome: json["welcome"] == null ? null : json["welcome"],
      );

  Map<String, dynamic> toJson() => {
        "welcome": welcome == null ? null : welcome,
      };
}
