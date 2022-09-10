import 'dart:convert';
import 'package:face26_mobile/backend/post.dart';
import 'package:flutter/material.dart';

class TrackerService {
  Post _post = Post();
  Future tracker(
      String trackId, String email, String event, BuildContext context) async {
    // var token = '';

    final apiUrl = 'tracker';
    Map data = {
      "event": event,
      "version": "rescue",
      "email": email,
      "source": null,
      "app": "rescueapp",
      "track_id": trackId,
      "browser": "",
      "os": "",
      "mobile": true
    };
    return _post.post(apiUrl, context, body: json.encode(data));
    //     .then((dynamic res) async {
    //   return TrackerModel.fromJson(res);
    // });
  }
}
