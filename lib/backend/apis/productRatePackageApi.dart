import 'package:http/http.dart';

class ProductRatePackageGet{
  Client client = Client();
  Future<Response> productPackagesInfo(/*String token*/) async {
    /*var header = {"x-access-token": token};*/ 
    final apiUrl = 'products';
    var result = Uri.https('api.face26.com', apiUrl);
    print(result);

    return client.get(result/**, headers: header */);
    // });
  }
  void dispose(){
    client.close();
  }
}