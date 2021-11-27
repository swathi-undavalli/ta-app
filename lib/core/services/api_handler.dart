import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

enum RequestType { Get, Post }

class API {
  static http.Response response;

  static Future apiHandler({
    @required String url,
    @required RequestType requestType,
    Map<String, String> header,
    dynamic body,
  }) async {
    if (requestType == RequestType.Get) {
      response = await http.get(
        Uri.parse(url),
        headers: header,
      );
    } else {
      response = await http.post(Uri.parse(url), headers: header, body: body,);
    }

    if (response.body != null) {
      return response.body;
    } else {
      return null;
    }
  }
}
