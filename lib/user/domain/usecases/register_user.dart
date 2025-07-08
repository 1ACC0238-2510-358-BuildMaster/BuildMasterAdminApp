import '../../data/repositories/user_repository_impl.dart';

class RegisterUser {
  final UserRepositoryImpl repository;
  RegisterUser(this.repository);

  Future<Map<String, dynamic>> call({
    required String email,
    required String username,
    required String password,
    String role = 'ADMIN',
  }) async {
    return await repository.register(
      email: email,
      username: username,
      password: password,
      role: role,
    );
  }
}
