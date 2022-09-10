import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:face26_mobile/backend/models/uploadModel.dart';

class UploadService {
  Future<UploadModel> uploadImage(String token, String path) async {
    var header = {"x-access-token": token};
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://api.face26.com/photo/upload'));
    request.files.add(await http.MultipartFile.fromPath('image', path)); //

    request.headers.addAll(header); //
    var response = await request.send();
    var result = await http.Response.fromStream(response);
    print(result.body);
    final json = jsonDecode(result.body) as Map<String, dynamic>;
    return UploadModel.fromJson(json);
  }

  Future<UploadModel> uploadImageWeb(String token, Uint8List byte) async {
    var header = {"x-access-token": token};
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://api.face26.com/photo/upload'));
    request.files.add(await http.MultipartFile.fromBytes('image', byte,
        filename: 'myImag.png')); //

    request.headers.addAll(header); //
    var response = await request.send();
    var result = await http.Response.fromStream(response);
    print(result.body);
    final json = jsonDecode(result.body) as Map<String, dynamic>;
    return UploadModel.fromJson(json);
  }
}
