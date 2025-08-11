import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:next_gen_metro/utils/global_variables.dart';
import 'package:next_gen_metro/utils/data/current_user_data.dart';

class ApiService {
  static final String _baseUrl = baseUrl;

  // --- Optional token management (works even if you don't set it) ---
  // Remove the CurrentUserData.token lookup entirely
static String? _authToken;
static void setAuthToken(String? token) => _authToken = token;

static Map<String, String> _headers({bool withAuth = false}) {
  return {
    'Content-Type': 'application/json',
    if (withAuth && _authToken != null && _authToken!.isNotEmpty)
      'Authorization': 'Bearer $_authToken',
  };
}


  // -------------------- Public APIs you already had --------------------

  static Future<Map<String, dynamic>> scanCard({
    required String uid,
    required String service,
  }) async {
    final uri = Uri.parse('$_baseUrl/scan');

    final response = await http.post(
      uri,
      headers: _headers(),
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
      headers: _headers(),
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
      headers: _headers(),
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      }),
    );

    // Consider checking status codes here too if you want strict handling
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> adminLogin({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/admin/login');

    final response = await http.post(
      uri,
      headers: _headers(),
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

  static Future<List<dynamic>> fetchRoutes() async {
    final uri = Uri.parse('$_baseUrl/admin/routes');
    final response = await http.get(uri, headers: _headers(withAuth: true));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to fetch routes');
    }
  }

  static Future<Map<String, dynamic>> addRoute({
    required String name,
    required String category,
    required String start,
    required String end,
  }) async {
    final uri = Uri.parse('$_baseUrl/admin/routes');
    final response = await http.post(
      uri,
      headers: _headers(withAuth: true),
      body: jsonEncode({
        'name': name,
        'category': category,
        'start': start,
        'end': end,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to add route');
    }
  }

  static Future<List<dynamic>> fetchUsers() async {
    final uri = Uri.parse('$_baseUrl/admin/users');
    final response = await http.get(uri, headers: _headers(withAuth: true));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  static Future<void> deleteUser(int id) async {
    final uri = Uri.parse('$_baseUrl/admin/users/$id');
    final response = await http.delete(uri, headers: _headers(withAuth: true));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }

  static Future<List<dynamic>> getAllRoutes() async {
    final uri = Uri.parse('$_baseUrl/admin/routes');
    final res = await http.get(uri, headers: _headers(withAuth: true));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List;
    }
    throw Exception('Failed to fetch routes');
  }

  static Future<void> createRoute({
    required String name,
    required String category,
    required String start,
    required String end,
  }) async {
    final uri = Uri.parse('$_baseUrl/admin/routes');
    final res = await http.post(
      uri,
      headers: _headers(withAuth: true),
      body: jsonEncode({
        'name': name,
        'category': category,
        'start': start,
        'end': end,
      }),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to create route');
    }
  }

  static Future<List<dynamic>> getAllUsers() async {
    final uri = Uri.parse('$_baseUrl/admin/users');
    final res = await http.get(uri, headers: _headers(withAuth: true));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List;
    }
    throw Exception('Failed to fetch users');
  }

  // -------------------- NEW: Profile APIs --------------------

  static Future<Map<String, dynamic>> getMe() async {
    final uri = Uri.parse('$_baseUrl/user/me');
    final res = await http.get(uri, headers: _headers(withAuth: true));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    try {
      final body = jsonDecode(res.body);
      if (body is Map && body['message'] is String) {
        throw Exception(body['message']);
      }
    } catch (_) {}
    throw Exception('Failed to fetch profile (HTTP ${res.statusCode})');
  }

  static Future<Map<String, dynamic>> updateMe({String? name, String? phone}) async {
    final uri = Uri.parse('$_baseUrl/user/me');
    final payload = <String, dynamic>{};
    if (name != null) payload['name'] = name;
    if (phone != null) payload['phone'] = phone;

    final res = await http.patch(
      uri,
      headers: _headers(withAuth: true),
      body: jsonEncode(payload),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    try {
      final body = jsonDecode(res.body);
      if (body is Map && body['message'] is String) {
        throw Exception(body['message']);
      }
    } catch (_) {}
    throw Exception('Failed to update profile (HTTP ${res.statusCode})');
  }
  static Future<Map<String, dynamic>> topupJazzcash({
  required int uid,
  required int amount,
}) async {
  final uri = Uri.parse('$_baseUrl/jazzcash/topup');
  final res = await http.post(
    uri,
    headers: _headers(withAuth: true), // if your endpoint needs auth; else _headers()
    body: jsonEncode({'uid': uid, 'amount': amount}),
  );

  if (res.statusCode == 200 || res.statusCode == 201) {
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  try {
    final body = jsonDecode(res.body);
    if (body is Map && body['message'] is String) {
      throw Exception(body['message']);
    }
  } catch (_) {}
  throw Exception('Top-up failed (HTTP ${res.statusCode})');
}

}
