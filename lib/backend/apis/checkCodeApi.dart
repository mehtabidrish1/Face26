import 'dart:convert';
import 'package:face26_mobile/backend/models/checkCodeModel.dart';
import 'package:face26_mobile/backend/post.dart';
import 'package:flutter/cupertino.dart';

class CheckCodeService {
  Post _post = Post();
  Future<CheckCodeModel> checkCode(
      int code, String email, BuildContext context) async {
    final apiUrl = 'auth/check_code';
    Map data = {"email": email, "code": code};
    return _post
        .post(apiUrl, context, body: json.encode(data))
        .then((dynamic res) {
      return CheckCodeModel.fromJson(res);
    });
  }
}
