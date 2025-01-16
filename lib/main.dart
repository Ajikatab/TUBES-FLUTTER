import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:tubes/screen/maps_screen.dart';
import 'screen/splash_screen.dart'; // Import splash screen
import 'screen/login_screen.dart'; // Import login screen
import 'screen/home_screen.dart'; // Import home screen
import 'screen/movie_screen.dart'; // Import movie screen (sebelumnya home_screen)
import 'screen/register_screen.dart'; // Import register screen
import 'screen/setting_screen.dart'; // Import about screen
import 'screen/news_screen.dart'; // Import news screen

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
        '/home': (context) => const HomeScreen(), // Route for movie screen
        '/movie': (context) => const MovieScreen(), // Route for movie screen
        '/setting': (context) => const SettingScreen(), // Route for about screen
        '/login': (context) => const LoginScreen(), // Route for login screen
        '/register': (context) => const RegisterScreen(), // Route for register screen
        '/news': (context) => const NewsScreen(), // Route for news screen
        '/maps': (context) => const MapsScreen(), // Route for maps screen
      },
    );
  }
}