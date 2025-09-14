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
    final uri = Uri.parse('$_baseUrl/auth/admin/login');

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

  // -------------------- Routes (Admin) --------------------

  static Future<List<dynamic>> fetchRoutes() async {
    final uri = Uri.parse('$_baseUrl/admin/routes');
    final response = await http.get(uri, headers: _headers(withAuth: true));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to fetch routes');
    }
  }

  /// UPDATED: now supports service + cities (while keeping old params)
  static Future<Map<String, dynamic>> addRoute({
    required String name,
    required String category, // will be sent as "service"
    required String start,
    required String end,
    String? startCity,        // NEW
    String? endCity,          // NEW
  }) async {
    final uri = Uri.parse('$_baseUrl/admin/routes');
    final payload = {
      'name': name,
      'service': category, // backend expects "service"
      'start': start,
      'end': end,
      if (startCity != null) 'startCity': startCity,
      if (endCity != null) 'endCity': endCity,
    };

    final response = await http.post(
      uri,
      headers: _headers(withAuth: true),
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to add route (HTTP ${response.statusCode})');
    }
  }

  static Future<List<dynamic>> fetchUsers() async {
    // Try /admin/users, fallback to /users if 404 (compat with refactor)
    final adminUri = Uri.parse('$_baseUrl/admin/users');
    final response = await http.get(adminUri, headers: _headers(withAuth: true));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }
    if (response.statusCode == 404) {
      final uri = Uri.parse('$_baseUrl/users');
      final r2 = await http.get(uri, headers: _headers(withAuth: true));
      if (r2.statusCode == 200) {
        return jsonDecode(r2.body) as List<dynamic>;
      }
    }
    throw Exception('Failed to fetch users');
  }

  static Future<void> deleteUser(int id) async {
    // Try /admin/users/:id, fallback to /users/:id if 404
    final adminUri = Uri.parse('$_baseUrl/admin/users/$id');
    var response = await http.delete(adminUri, headers: _headers(withAuth: true));
    if (response.statusCode == 200) return;

    if (response.statusCode == 404) {
      final uri = Uri.parse('$_baseUrl/users/$id');
      response = await http.delete(uri, headers: _headers(withAuth: true));
      if (response.statusCode == 200) return;
    }
    throw Exception('Failed to delete user');
  }

  static Future<List<dynamic>> getAllRoutes() async {
    final uri = Uri.parse('$_baseUrl/admin/routes');
    final res = await http.get(uri, headers: _headers(withAuth: true));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List;
    }
    throw Exception('Failed to fetch routes');
  }

  /// UPDATED: now supports service + cities (while keeping old params)
  static Future<void> createRoute({
    required String name,
    required String category, // will be sent as "service"
    required String start,
    required String end,
    String? startCity,        // NEW
    String? endCity,          // NEW
  }) async {
    final uri = Uri.parse('$_baseUrl/admin/routes');
    final body = {
      'name': name,
      'service': category, // backend expects "service"
      'start': start,
      'end': end,
      if (startCity != null) 'startCity': startCity,
      if (endCity != null) 'endCity': endCity,
    };

    final res = await http.post(
      uri,
      headers: _headers(withAuth: true),
      body: jsonEncode(body),
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      try {
        final bodyJson = jsonDecode(res.body);
        if (bodyJson is Map && bodyJson['message'] is String) {
          throw Exception(bodyJson['message']);
        }
      } catch (_) {}
      throw Exception('Failed to create route (HTTP ${res.statusCode})');
    }
  }

  static Future<List<dynamic>> getAllUsers() async {
    // same fallback logic as fetchUsers
    final adminUri = Uri.parse('$_baseUrl/admin/users');
    final res = await http.get(adminUri, headers: _headers(withAuth: true));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List;
    }
    if (res.statusCode == 404) {
      final uri = Uri.parse('$_baseUrl/users');
      final r2 = await http.get(uri, headers: _headers(withAuth: true));
      if (r2.statusCode == 200) {
        return jsonDecode(r2.body) as List;
      }
    }
    throw Exception('Failed to fetch users');
  }

  // -------------------- NEW: Fare APIs (Admin) --------------------

  static Future<List<dynamic>> getFares() async {
    final uri = Uri.parse('$_baseUrl/admin/fares');
    final res = await http.get(uri, headers: _headers(withAuth: true));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List<dynamic>;
    }
    throw Exception('Failed to fetch fares (HTTP ${res.statusCode})');
  }

  static Future<Map<String, dynamic>> upsertFare({
    required String service, // Orange | Speedo | Metro
    required int price,
  }) async {
    final uri = Uri.parse('$_baseUrl/admin/fares');
    final res = await http.post(
      uri,
      headers: _headers(withAuth: true),
      body: jsonEncode({'service': service, 'price': price}),
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
    throw Exception('Failed to save fare (HTTP ${res.statusCode})');
  }

  static Future<void> deleteFare(String service) async {
    final uri = Uri.parse('$_baseUrl/admin/fares/$service');
    final res = await http.delete(uri, headers: _headers(withAuth: true));
    if (res.statusCode != 200) {
      try {
        final body = jsonDecode(res.body);
        if (body is Map && body['message'] is String) {
          throw Exception(body['message']);
        }
      } catch (_) {}
      throw Exception('Failed to delete fare (HTTP ${res.statusCode})');
    }
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
