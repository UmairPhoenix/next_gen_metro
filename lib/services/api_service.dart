import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Point this at your live Node.js server
  static const String _baseUrl = 'http://192.168.1.108:3000';

  /// Scans [uid] for [service] ("Metro","Speedo","Orange")
  /// and returns the decoded JSON response as a Map.
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
      // 200 == trip started/ended; 404 == user not found
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  }

  /// Logs in a user with [email] and [password].
  /// Returns a Map with 'token' and 'user' keys.
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
      // You get: { token: "...", user: { ... } }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      // Try to extract a clean message
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
