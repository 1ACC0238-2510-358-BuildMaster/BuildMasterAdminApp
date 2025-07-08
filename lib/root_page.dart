import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../user/presentation/providers/user_provider.dart';
import '../user/presentation/pages/user_login_page.dart';
import 'dashboard_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    if (userProvider.token == null) {
      // Not logged in, show login
      return Navigator(
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => const UserLoginPage(),
        ),
      );
    } else {
      // Logged in, show dashboard
      return const DashboardPage();
    }
  }
}
