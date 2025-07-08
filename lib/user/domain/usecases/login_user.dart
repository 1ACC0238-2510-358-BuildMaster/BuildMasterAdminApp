import '../../data/repositories/user_repository_impl.dart';

class LoginUser {
  final UserRepositoryImpl repository;
  LoginUser(this.repository);

  Future<String> call({
    required String email,
    required String password,
  }) async {
    return await repository.login(email: email, password: password);
  }
}
