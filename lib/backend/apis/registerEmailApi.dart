import 'dart:convert';
import 'package:face26_mobile/backend/post.dart';
import 'package:flutter/material.dart';

class RegisterEmailService {
  Post _post = Post();
  Future registerEmail(String token, String email, BuildContext context) async {
    final apiUrl = 'auth/registration';
    Map data = {
      "access_token_temporary": token,
      "email": email,
    };
    return _post.post(apiUrl, context, body: json.encode(data));
  }
}
