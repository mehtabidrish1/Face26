import 'dart:convert';
import 'package:face26_mobile/backend/models/syncModel.dart';
import 'package:face26_mobile/backend/post.dart';
import 'package:flutter/material.dart';

class SyncService {
  Post _post = Post();
  Future<SyncModel> sync(String token, BuildContext context) async {
    Map<String, String>? header = {"x-access-token": token};

    final apiUrl = 'user/sync';
    return _post
        .get(apiUrl, context, headers: header)
        .then((dynamic res) async {
      return SyncModel.fromJson(res);
    });
  }
}
