import 'dart:convert';
import 'package:face26_mobile/backend/models/photoInfoModel.dart';
import 'package:http/http.dart' show Client;

class PhotoInfoService {
  Client client = Client();
  Future<PhotoInfoModel> photoInfo(String token, String? oid) async {
    var header = {"x-access-token": token};
    final apiUrl = 'user/photo_info';
    var result = Uri.https('api.face26.com', apiUrl, {'photo_id': oid});
    print(result);
    return client.get(result, headers: header).then((response) async {
      String res = response.body;
      return PhotoInfoModel.fromJson(jsonDecode(res));
    });
  }
}
