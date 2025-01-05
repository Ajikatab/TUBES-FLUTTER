import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import halaman home
import 'admin_screen.dart'; // Import halaman admin

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Fungsi untuk memverifikasi login
  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (_formKey.currentState?.validate() ?? false) {
      // Mengecek apakah username dan password cocok dengan admin atau customer
      if (username == 'admin' && password == 'admin123') {
        // Jika admin
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => AdminScreen()), // Arahkan ke halaman admin
        );
      } else if (username == 'customer' && password == 'customer123') {
        // Jika customer
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen()), // Arahkan ke halaman home
        );
      } else {
        // Jika username atau password salah
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Username atau Password salah!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
