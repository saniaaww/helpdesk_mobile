import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "http://192.168.30.209:8000/api";

  static Future login(String email, String password) async {
    try {
      print("HIT API");

      var response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "email": email,
          "password": password
        },
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      return jsonDecode(response.body);
    } catch (e) {
      print("ERROR API: $e");
      rethrow;
    }
  }
}