import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Import splash screen
import 'login_screen.dart'; // Import login screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // Halaman pertama yang muncul adalah SplashScreen
      routes: {
        '/login': (context) =>
            const LoginScreen(), // Menambahkan rute untuk halaman login
        // Rute lainnya bisa ditambahkan di sini, misalnya '/home', '/admin', dll.
      },
    );
  }
}
