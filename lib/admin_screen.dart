import 'package:flutter/material.dart';
import 'shop_screen.dart'; // Mengimpor halaman untuk mengelola souvenir

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
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
            padding: EdgeInsets.all(16.0),
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
              child: Text('Manage Souvenir Shop'),
            ),
          ),
          // Di sini Anda bisa menambahkan fungsionalitas lain jika diperlukan
        ],
      ),
    );
  }
}
