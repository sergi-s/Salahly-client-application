import 'package:http/http.dart' as http;
import 'dart:convert';

Future<dynamic> httpRequest(String url) async {
  http.Response response = await http.get(Uri.parse(url));
  try {
    if (response.statusCode == 200) {
      String jsonData = response.body;
      var decodeData = jsonDecode(jsonData);
      return decodeData;
    } else {
      return "failed";
    }
  } catch (e) {
    return "failed";
  }
}
