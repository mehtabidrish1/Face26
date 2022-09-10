import 'dart:convert';
import 'package:face26_mobile/backend/models/paymentIntentModel.dart';
import 'package:http/http.dart' show Client;

class PaymentIntentService {
  Client client = Client();
  Future<PaymentIntentModel> paymentIntent(String token) async {
    var header = {"x-access-token": token, 'Content-Type': 'application/json'};
    const apiUrl = 'create_payment_intent';
    var body = json.encode({
      "item": {
        "description": "",
        "highlight": true,
        "id": "credits_10",
        "price": 5,
        "quantity": 10,
        "title": "10x Fotos freischalten"
      }
    });
    var result = Uri.https('api.face26.com', apiUrl);
    return client.post(result, body: body, headers: header).then((response) {
      String res = response.body;
      return PaymentIntentModel.fromJson(jsonDecode(res));
    });
    //     .then((dynamic res) async {
    //   return TrackerModel.fromJson(res);
    // });
  }
}
