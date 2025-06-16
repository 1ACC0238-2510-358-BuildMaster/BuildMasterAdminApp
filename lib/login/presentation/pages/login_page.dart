import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  @override Widget build(BuildContext c) => Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
          padding: EdgeInsets.all(16), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextField(controller: _email, decoration: InputDecoration(labelText: 'Email')),
        TextField(controller: _password, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
        SizedBox(height: 16), _busy ? CircularProgressIndicator() : ElevatedButton(
            onPressed: () async {
              setState(() => _busy = true);
              try {
                await context.read<AuthProvider>().login(_email.text, _password.text);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
              }
              setState(() => _busy = false);
            }, child: Text('Login')
        ),
        TextButton(onPressed: () => Navigator.push(c, MaterialPageRoute(builder: (_) => RegisterPage())), child: Text('Register'))
      ])
      )
  );
}