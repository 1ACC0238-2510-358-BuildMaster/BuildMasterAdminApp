import 'dart:convert';
import 'package:http/http.dart' as http;

class UserApiService {
  static const String baseUrl = 'https://buildmaster-api-ddh3asdah2bsggfs.canadacentral-01.azurewebsites.net';
  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  Map<String, String> get _authHeaders => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Future<Map<String, dynamic>> register({
    required String email,
    required String username,
    required String password,
    String role = 'ADMIN',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/register'),
      headers: _authHeaders,
      body: jsonEncode({
        'email': email,
        'username': username,
        'password': password,
        'role': role,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register user: \\${response.body}');
    }
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      return response.body.replaceAll('"', '');
    } else {
      throw Exception('Failed to login: \\${response.body}');
    }
  }

  Future<Map<String, dynamic>> getMe() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/me'),
      headers: _authHeaders,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch user info: ${response.body}');
    }
  }
}
