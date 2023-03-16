import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as convert;

class YenePayServices {
  String domain = 'https://testapi.yenepay.com/api'; // For Development
  // String domain = 'https://endpoints.yenepay.com/api/urlgenerate/getcheckouturl/'; // For Production
  String merchantId = "1028";
  String merchentOrderId = null;
  String process = 'Express';

  Future<Map<String, String>> createYenePayPayment(payload) async {
    try {
      var response = await http.post(
          Uri.parse("$domain/urlgenerate/getcheckouturl/"),
          body: convert.jsonEncode(payload),
          headers: {
            "content-type": "application/json",
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (body["result"] != null) {
          String executeUrl = body["result"];
          return {"executeUrl": executeUrl};
        }
        return null;
      } else {
        print(body);
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> executePayment(url, payload) async {
    try {
      var response =
          await http.post(url, body: convert.jsonEncode(payload), headers: {
        "content-type": "application/json",
      });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return body["id"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
