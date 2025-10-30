
import 'package:flutter/material.dart';
import 'firebase_add_data.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Page"),),
      body: Column(children: [
        Center(
          child: ElevatedButton(onPressed: () async{
            await GoogleAuthService().signInWithGoogle();
          }, child: Text("Login With google")),
        ),

        Center(
          child: ElevatedButton(onPressed: () async{
            await GoogleAuthService().signOut();
          }, child: Text("Sign out")),
        )
      ],),
    );
  }
}
