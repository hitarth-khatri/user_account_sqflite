import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:task1/app_screens/login_screen.dart';
import 'user_screen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final Future _pref = SharedPreferences.getInstance();
  String? email;

  @override
  void initState(){
    super.initState();
    getUserData();
    Timer(const Duration(seconds: 2),
        (){
      if(email == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const LoginPage()
          ),
        );
      }
      else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const UserPage()
          ),
        );
      }

        }
    );
  }

  Future getUserData() async {
    final SharedPreferences sp = await _pref;
    setState(() {
      email = sp.getString("email");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.teal[100],
        padding: const EdgeInsets.all(50),
          child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
