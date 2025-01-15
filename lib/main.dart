import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:tubes/maps_screen.dart';
import 'splash_screen.dart'; // Import splash screen
import 'login_screen.dart'; // Import login screen
import 'home_screen.dart'; // Import home screen
import 'register_screen.dart'; // Import register screen
import 'about.dart'; // Import about screen
import 'news_screen.dart'; // Import news screen

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Pastikan widget binding sudah terinisialisasi
  await Firebase.initializeApp(); // Inisialisasi Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Silver Screen Saga',
      theme: ThemeData(
        primaryColor: const Color(0xFFE0E0E0),
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        colorScheme: ColorScheme.dark(
          primary: Colors.grey[300]!,
          secondary: Colors.grey[400]!,
          surface: const Color(0xFF2C2C2C),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF1E1E1E),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.grey[300],
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.grey[300]),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // Initial screen shown is SplashScreen
      routes: {
        '/home': (context) => const HomeScreen(), // Route for home screen
        '/about': (context) => const AboutScreen(), // Route for about screen
        '/login': (context) => const LoginScreen(), // Route for login screen
        '/register': (context) => const RegisterScreen(), // Route for register screen
        '/news': (context) => const NewsScreen(), // Route for news screen
        '/maps': (context) => const MapsScreen(), // Route for news screen
        
      },
    );
  }
}
