import 'dart:convert';

PhotoInfoModel photoInfoModelFromJson(String str) =>
    PhotoInfoModel.fromJson(json.decode(str));

String photoInfoModelToJson(PhotoInfoModel data) => json.encode(data.toJson());

class PhotoInfoModel {
  PhotoInfoModel({
    this.id,
    this.faces,
    this.purchased,
    this.timestampCreated,
    this.userId,
  });

  Id? id;
  int? faces;
  bool? purchased;
  TimestampCreated? timestampCreated;
  Id? userId;

  factory PhotoInfoModel.fromJson(Map<String, dynamic> json) => PhotoInfoModel(
        id: json["_id"] == null ? null : Id.fromJson(json["_id"]),
        faces: json["faces"] == null ? null : json["faces"],
        purchased: json["purchased"] == null ? null : json["purchased"],
        timestampCreated: json["timestamp_created"] == null
            ? null
            : TimestampCreated.fromJson(json["timestamp_created"]),
        userId: json["user_id"] == null ? null : Id.fromJson(json["user_id"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id!.toJson(),
        "faces": faces == null ? null : faces,
        "purchased": purchased == null ? null : purchased,
        "timestamp_created":
            timestampCreated == null ? null : timestampCreated!.toJson(),
        "user_id": userId == null ? null : userId!.toJson(),
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
