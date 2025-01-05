import 'package:flutter/material.dart';
import 'shop_screen.dart'; // Mengimpor halaman untuk mengelola souvenir

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Aksi logout atau keluar dari aplikasi
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman pengaturan souvenir
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShopScreen(),
                  ),
                );
              },
              child: const Text('Manage Souvenir Shop'),
            ),
          ),
          // Di sini Anda bisa menambahkan fungsionalitas lain jika diperlukan
        ],
      ),
    );
  }
}
