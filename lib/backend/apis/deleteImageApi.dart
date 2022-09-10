import 'dart:convert';
import 'package:http/http.dart' show Client, Response;

class DeleteImageService {
  Client client = Client();
  Future<Response> deleteImage(String token, String oid) async {
    var header = {"x-access-token": token};
    final apiUrl = 'user/delete_photo';
    var result = Uri.https('api.face26.com', apiUrl, {'photo_id': oid});
    print(result);

    return client.get(result, headers: header);
    // });
  }
}
