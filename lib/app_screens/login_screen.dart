import 'package:flutter/material.dart';
import 'package:task1/app_utils/app_strings.dart';
import 'package:task1/database_helper/db_helper.dart';
import 'package:task1/validation/validation.dart';
import 'user_screen.dart';
import 'signup_update_screen.dart';
import 'package:task1/shared_pref.dart';
import 'package:task1/app_utils/app_images.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool _obscureText = true;
  String? email;
  String? username;
  int? number;
  String? gender;
  String? birthDate;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(loginStr),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              //image
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Image.asset(loginImg,height: 150,width: 150,),
              ),

              //email
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: emailStr,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return requiredField;
                    }
                    if (!validateEmail(value)) {
                      return enterValidEmail;
                    }
                    return null;
                  },
                ),
              ),

              //password
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextFormField(
                  controller: passController,
                  obscureText: _obscureText,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: passStr,
                    suffixIcon: passwordShow(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return requiredField;
                    }
                    if (!validatePassword(value)) {
                      return enterValidPass;
                    }
                    return null;
                  },
                ),
              ),

              //login button
              ElevatedButton(
                onPressed: login,
                child: const Text(loginStr),
              ),

              //new user button
              TextButton(
                onPressed: () {
                  setState(() {
                    List? users;
                    int? index;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignupPage(isLoggedin: false, users: users,index: index,)
                      ),
                    );
                  });

                },
                child: const Text(
                  newUser,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //show password widget
  Widget passwordShow() => IconButton(
    onPressed: () {
      setState(() {
        _obscureText = !_obscureText;
      });
    },
    icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
  );

  //onPressed login button
  login() async {
    String email = emailController.text;
    String password = passController.text;

    if (_formKey.currentState!.validate()) {
      await dbHelper.getUser(email, password).then((userData) {
        if (userData != null) {
          setSP(userData).whenComplete(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UserPage()),
            );
          });
        } else {
          const snackBar = SnackBar(
            content: Text(invalidUser),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    }
  }

}
