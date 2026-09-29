import 'dart:convert';

import 'package:http/http.dart' as http;

// Gọi HTTP GET và giải mã JSON trả về.
class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  Future<dynamic> getData() async {
    final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 25));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('HTTP ${response.statusCode}: ${response.body}');
  }
}
