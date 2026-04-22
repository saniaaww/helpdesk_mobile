import 'package:flutter/material.dart';
import 'screens/auth/splash_screen.dart'; // Ubah import ke SplashScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Ganti LoginPage menjadi SplashScreen
      home: const SplashScreen(), 
      debugShowCheckedModeBanner: false,
    );
  }
}