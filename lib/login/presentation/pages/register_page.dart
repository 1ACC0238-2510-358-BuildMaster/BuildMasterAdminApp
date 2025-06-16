import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends StatefulWidget { @override _RegisterPageState createState() => _RegisterPageState(); }
class _RegisterPageState extends State<RegisterPage> {
  final _email=TextEditingController(), _password=TextEditingController(), _name=TextEditingController();
  String _role='user'; bool _busy=false;
  @override Widget build(BuildContext c)=>Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(padding: EdgeInsets.all(16), child: ListView(children: [
        TextField(controller:_email,decoration:InputDecoration(labelText:'Email')),
        TextField(controller:_password,decoration:InputDecoration(labelText:'Password'),obscureText:true),
        TextField(controller:_name,decoration:InputDecoration(labelText:'Name')),
        DropdownButtonFormField<String>(value:_role,items:[DropdownMenuItem(value:'user',child:Text('User')),DropdownMenuItem(value:'admin',child:Text('Administrator'))],onChanged:(v)=>setState(()=>_role=v!),decoration:InputDecoration(labelText:'Role')),
        SizedBox(height:16),_busy?CircularProgressIndicator():ElevatedButton(onPressed:()async{setState(()=>_busy=true);try{await context.read<AuthProvider>().register(_email.text,_password.text,_name.text,_role);Navigator.pop(c);}catch(e){ScaffoldMessenger.of(c).showSnackBar(SnackBar(content:Text(e.toString())));}setState(()=>_busy=false);},child:Text('Register'))
      ]))
  );
}