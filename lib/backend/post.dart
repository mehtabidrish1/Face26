import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client;

class Post {
  final JsonDecoder _decoder = JsonDecoder();
  Client client = Client();

  // post methods data
  Future<dynamic> post(url, BuildContext context,
      {Map? headers, body, encoding}) async {
    // User firebaseUser = FirebaseAuth.instance.currentUser;
    // if (firebaseUser == null) {
    //   firebaseUser = await FirebaseAuth.instance.authStateChanges().first;
    // }
    //var token = await firebaseUser.getIdToken();

    final apiUrl = Uri.https("api.face26.com", url);
    print(apiUrl);
    return client
        .post(apiUrl,
            body: body,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json'
            },
            encoding: encoding)
        .then((response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
            content: Text(
              res.toString(),
              textAlign: TextAlign.center,
            )));
        throw Exception("Error while fetching data");
      }
      if (response.body.isEmpty) {
        return "1";
      }
      return _decoder.convert(res);
    });
  }

  //get methods data
  Future<dynamic> get(String url, BuildContext context,
      {Map<String, String>? headers}) async {
    final apiUrl = Uri.https("api.face26.com", url);
    print(apiUrl);
    return client.get(apiUrl, headers: headers).then((response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
            content: Text(
              res.toString(),
              textAlign: TextAlign.center,
            )));
        throw Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }
}
