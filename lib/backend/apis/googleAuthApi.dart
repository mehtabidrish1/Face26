import 'dart:convert';
import 'package:face26_mobile/backend/models/googleAuthModel.dart';
import 'package:http/http.dart' show Client;

class GoogleAuthService {
  Client client = Client();
  Future<GoogleAuthModel> googleAuth(String clientId,String googleToken) async {
    var header = {'Content-Type': 'application/json'};
    const apiUrl = 'auth/google';
    var body = json.encode({
      "auth_code": {
        "clientId": clientId,
        "credential": googleToken,
        "select_by": "btn_add_session"
      }
    });
    var result = Uri.https('api.face26.com', apiUrl);
    return client.post(result, body: body, headers: header).then((response) {
      String res = response.body;
      return GoogleAuthModel.fromJson(jsonDecode(res));
    });
  }
}

                                                             