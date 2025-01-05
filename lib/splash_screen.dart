import 'package:flutter/material.dart';
import 'login_screen.dart'; // Ganti dengan rute login screen yang sesuai

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  // Fungsi untuk mengarahkan pengguna ke halaman login setelah 3 detik
  _navigateToLogin() async {
    await Future.delayed(
        Duration(seconds: 3)); // Tampilkan splash screen selama 3 detik
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginScreen()), // Arahkan ke halaman login
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Warna latar belakang splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo atau teks selamat datang
            Icon(
              Icons
                  .movie_creation, // Ikon film, bisa diganti dengan logo aplikasi
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Movie App',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
