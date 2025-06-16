import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../data/datasources/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService service;
  String? _token;
  User? _user;

  AuthProvider({required String baseUrl}) : service = AuthService(baseUrl: baseUrl);

  bool get isLoggedIn => _token != null;
  User? get user => _user;

  Future<void> login(String email, String password) async {
    _token = await service.login(email, password);
    _user = await service.fetchCurrentUser(_token!);
    notifyListeners();
  }

  Future<void> register(String email, String password, String name, String role) async {
    await service.register(email, password, name, role);
  }

  Future<void> updateProfile(String name, String role) async {
    if (_token == null) throw Exception('Not authenticated');
    await service.updateProfile(_token!, name, role);
    _user = User(id: _user!.id, email: _user!.email, name: name, role: role);
    notifyListeners();
  }

  void logout() {
    _token = null;
    _user = null;
    notifyListeners();
  }
}
