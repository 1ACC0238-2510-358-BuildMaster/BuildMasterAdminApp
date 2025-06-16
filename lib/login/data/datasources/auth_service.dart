import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/user.dart';

class AuthService {
  final String baseUrl;

  AuthService({required this.baseUrl});

  Future<String> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('\$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body)['token'] as String;
    }
    throw Exception('Failed to login: \${res.body}');
  }

  Future<User> fetchCurrentUser(String token) async {
    final res = await http.get(
      Uri.parse('\$baseUrl/me'),
      headers: {'Authorization': 'Bearer \$token'},
    );
    if (res.statusCode == 200) {
      return User.fromJson(jsonDecode(res.body));
    }
    throw Exception('Failed to fetch user');
  }

  Future<void> register(String email, String password, String name, String role) async {
    final res = await http.post(
      Uri.parse('\$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
        'role': role,
      }),
    );
    if (res.statusCode != 200) throw Exception('Registration failed');
  }

  Future<void> updateProfile(String token, String name, String role) async {
    final res = await http.put(
      Uri.parse('\$baseUrl/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer \$token',
      },
      body: jsonEncode({'name': name, 'role': role}),
    );
    if (res.statusCode != 200) throw Exception('Update failed');
  }
}
