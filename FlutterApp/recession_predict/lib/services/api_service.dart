

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl =
      'http://192.168.100.11:8000'; // Localhost for Android emulator

  static Future<String> predict(Map<String, dynamic> inputData) async {
    final uri = Uri.parse("$_baseUrl/predict");
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(inputData),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['prediction'].toString();
    } else {
      throw Exception("Failed to get prediction: ${response.body}");
    }
  }
}
