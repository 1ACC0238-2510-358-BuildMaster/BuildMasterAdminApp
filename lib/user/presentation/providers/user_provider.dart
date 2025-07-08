import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/shared_preferences_helper.dart';
import '../../data/datasources/user_api_service.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/register_user.dart';

class UserProvider extends ChangeNotifier {
  final UserRepositoryImpl repository = UserRepositoryImpl(apiService: UserApiService());
  String? token;
  String? errorMessage;
  bool isLoading = false;
  String? email;
  String? username;

  static const String _tokenKey = 'auth_token';

  UserProvider() {
    _loadToken().then((_) => ensureUserInfoLoaded());
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString(_tokenKey);
    if (savedToken != null) {
      token = savedToken;
      repository.setToken(token);
      notifyListeners();
    }
  }

  Future<void> _saveToken(String? newToken) async {
    final prefs = await SharedPreferences.getInstance();
    if (newToken != null) {
      await prefs.setString(_tokenKey, newToken);
    } else {
      await prefs.remove(_tokenKey);
    }
  }

  Future<void> fetchUserInfo() async {
    if (token == null) return;
    try {
      final userInfo = await repository.getMe();
      username = userInfo['username'] ?? username;
      notifyListeners();
    } catch (e) {
      // Optionally handle error
    }
  }

  Future<void> ensureUserInfoLoaded() async {
    if (token != null && (username == null || username!.isEmpty)) {
      await fetchUserInfo();
    }
  }

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final loginUser = LoginUser(repository);
      token = await loginUser.call(email: email, password: password);
      repository.setToken(token); // Set token for authenticated requests
      await _saveToken(token); // Persist token
      this.email = email;
      await fetchUserInfo();
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String username, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final registerUser = RegisterUser(repository);
      await registerUser.call(email: email, username: username, password: password);
      this.email = email;
      this.username = username;
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    token = null;
    email = null;
    username = null;
    repository.setToken(null); // Clear token from API service
    _saveToken(null); // Remove token from storage
    notifyListeners();
  }
}
