import '../datasources/user_api_service.dart';

class UserRepositoryImpl {
  final UserApiService apiService;
  UserRepositoryImpl({required this.apiService});

  void setToken(String? token) {
    apiService.setToken(token);
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String username,
    required String password,
    String role = 'USER',
  }) async {
    return await apiService.register(
      email: email,
      username: username,
      password: password,
      role: role,
    );
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    return await apiService.login(email: email, password: password);
  }

  Future<Map<String, dynamic>> getMe() async {
    return await apiService.getMe();
  }
}
