import 'dart:convert';
import 'package:http/http.dart' show Client, Response;

class OptimizeService {
  Client client = Client();
  Future<Response> optimize(String token, String oid) async {
    var header = {"x-access-token": token};
    final apiUrl = 'optimization';
    var result = Uri.https('api.face26.com', apiUrl, {'photo_id': oid});
    print(result);

    return client.get(result, headers: header);
    // });
  }
}
