import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../presentation/pages/login_page.dart';
import '../../presentation/pages/profile_page.dart';
import '../../presentation/pages/register_page.dart';

/// Embeddable login flow. Call LoginFlow(baseUrl: 'https://api.myapp.com/auth')
/// within your app to handle authentication.
class LoginFlow extends StatelessWidget {
  final String baseUrl;
  final VoidCallback? onAuthenticated;

  const LoginFlow({Key? key, required this.baseUrl, this.onAuthenticated}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(baseUrl: baseUrl),
      child: Consumer<AuthProvider>(
        builder: (_, auth, __) {
          if (auth.isLoggedIn) {
            if (onAuthenticated != null) WidgetsBinding.instance.addPostFrameCallback((_) => onAuthenticated!());
            return ProfilePage();
          }
          return LoginPage();
        },
      ),
    );
  }
}
