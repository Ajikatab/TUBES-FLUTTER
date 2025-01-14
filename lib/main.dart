import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Import splash screen
import 'login_screen.dart'; // Import login screen
import 'home_screen.dart'; // Import home screen
// import 'shop_screen.dart'; // Import shop screen (commented out)
import 'about.dart'; // Import about screen
import 'shop_pelanggan_screen.dart'; // Import shop pelanggan screen
import 'news_screen.dart'; // Import news screen

void main() {
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
        '/store': (context) => const ShopPelangganScreen(), // Route for shop screen
        '/about': (context) => const AboutScreen(), // Route for about screen
        '/login': (context) => const LoginScreen(), // Route for login screen
        '/news': (context) => const NewsScreen(), // Route for news screen
      },
    );
  }
}
