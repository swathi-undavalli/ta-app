import 'package:http/http.dart' as http;

enum RequestType { Get, Post }

class API {
  static late http.Response response;

  static Future apiHandler({
    required String url,
    required RequestType requestType,
    Map<String, String>? header,
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

    if (response.body != '') {
      return response.body;
    } else {
      return null;
    }
  }
}
