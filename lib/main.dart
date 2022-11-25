import 'package:flutter/material.dart';
import 'package:task1/app_screens/splash_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.indigo,
      fontFamily: 'Ubuntu',
      textTheme: const TextTheme(
        bodyText2: TextStyle(fontSize: 18),
      ),
    ),
    home: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: SplashPage(),
      ),
    );
  }
}
