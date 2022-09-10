import 'dart:convert';

UploadModel uploadModelFromJson(String str) =>
    UploadModel.fromJson(json.decode(str));

String uploadModelToJson(UploadModel data) => json.encode(data.toJson());

class UploadModel {
  UploadModel({
    required this.photoId,
  });

  PhotoId photoId;

  factory UploadModel.fromJson(Map<String, dynamic> json) => UploadModel(
        photoId: PhotoId.fromJson(json["photo_id"]),
      );

  Map<String, dynamic> toJson() => {
        "photo_id": photoId.toJson(),
      };
}

class PhotoId {
  PhotoId({
    required this.oid,
  });

  String oid;

  factory PhotoId.fromJson(Map<String, dynamic> json) => PhotoId(
        oid: json["\u0024oid"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024oid": oid,
      };
}
