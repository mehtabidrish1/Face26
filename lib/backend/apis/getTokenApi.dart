import 'dart:convert';

import 'package:face26_mobile/backend/models/getTokenModel.dart';
import 'package:face26_mobile/backend/post.dart';
import 'package:flutter/cupertino.dart';

class GetTokenService {
  Post _post = Post();
  Future<GetTokenModel> getToken(BuildContext context) async {
    final apiUrl = 'auth/registration_temporary';

    return _post.post(apiUrl, context, body: null).then((res) async {
      return GetTokenModel.fromJson(res);
    });

    // catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       backgroundColor: Colors.red,
    //       duration: Duration(seconds: 5),
    //       content: Text(
    //         e.toString(),
    //         textAlign: TextAlign.center,
    //       )));
    // }
  }
}
