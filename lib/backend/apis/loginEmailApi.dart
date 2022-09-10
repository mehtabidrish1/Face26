import 'dart:convert';
import 'package:face26_mobile/backend/post.dart';
import 'package:flutter/material.dart';

class LoginEmailService {
  Post _post = Post();
  Future loginEmail(String email, BuildContext context) async {
    final apiUrl = 'auth/login_link';
    Map data = {
      "email": email,
    };
    return _post.post(apiUrl, context, body: json.encode(data));
  }
}
