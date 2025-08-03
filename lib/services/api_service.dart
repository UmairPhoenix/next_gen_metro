import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:next_gen_metro/utils/global_variables.dart';

class ApiService {
  static final String _baseUrl = baseUrl;

  static Future<Map<String, dynamic>> scanCard({
    required String uid,
    required String service,
  }) async {
    final uri = Uri.parse('$_baseUrl/scan');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'uid': uid, 'service': service}),
    );

    if (response.statusCode == 200 || response.statusCode == 404) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/auth/login');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      String message = "Login failed";
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body.containsKey('message')) {
          message = body['message'];
        }
      } catch (_) {}
      throw Exception(message);
    }
  }

  static Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/auth/signup');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      }),
    );

    print('Signup Response (${response.statusCode}): ${response.body}');
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
