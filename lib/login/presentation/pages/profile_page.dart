import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfilePage extends StatefulWidget{@override _ProfilePageState createState()=>_ProfilePageState();}
class _ProfilePageState extends State<ProfilePage>{
  late TextEditingController _nameCtr;
  late String _role;
  bool _busy=false;
  @override void initState(){super.initState();final u=context.read<AuthProvider>().user!;_nameCtr=TextEditingController(text:u.name);_role=u.role;}
  @override Widget build(BuildContext c){final auth=context.read<AuthProvider>();final u=auth.user!;return Scaffold(
      appBar:AppBar(title:Text('Profile'),actions:[IconButton(icon:Icon(Icons.logout),onPressed:auth.logout)]),
      body:Padding(padding:EdgeInsets.all(16),child:Column(children:[
        TextField(controller:_nameCtr,decoration:InputDecoration(labelText:'Name')),
        DropdownButtonFormField<String>(value:_role,items:[DropdownMenuItem(value:'user',child:Text('User')),DropdownMenuItem(value:'admin',child:Text('Administrator'))],onChanged:(v)=>setState(()=>_role=v!),decoration:InputDecoration(labelText:'Role')),
        SizedBox(height:16),_busy?CircularProgressIndicator():ElevatedButton(onPressed:()async{setState(()=>_busy=true);try{await auth.updateProfile(_nameCtr.text,_role);ScaffoldMessenger.of(c).showSnackBar(SnackBar(content:Text('Profile updated')));}catch(e){ScaffoldMessenger.of(c).showSnackBar(SnackBar(content:Text(e.toString())));}setState(()=>_busy=false);},child:Text('Update Profile')),
        if(u.role=='admin')...[
          SizedBox(height:24),Text('Admin Panel',style:TextStyle(fontWeight:FontWeight.bold)),
          // embed admin BC or navigate to admin module
        ]
      ])));
  }
}
