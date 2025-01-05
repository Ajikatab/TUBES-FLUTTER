import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Import splash screen
import 'login_screen.dart'; // Import login screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Halaman pertama yang muncul adalah SplashScreen
      routes: {
        '/login': (context) =>
            LoginScreen(), // Menambahkan rute untuk halaman login
        // Rute lainnya bisa ditambahkan di sini, misalnya '/home', '/admin', dll.
      },
    );
  }
}
