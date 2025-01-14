import 'package:flutter/material.dart';

class DetailMerchScreen extends StatelessWidget {
  final String name;
  final String description;
  final double price;
  final String? imageUrl;

  const DetailMerchScreen({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Detail Merchandise',
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.35, // Menggunakan 35% tinggi layar
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.movie_filter,
                            size: MediaQuery.of(context).size.width * 0.25, // 25% lebar layar
                            color: Colors.amber,
                          );
                        },
                      )
                    : Icon(
                        Icons.movie_filter,
                        size: MediaQuery.of(context).size.width * 0.25, // 25% lebar layar
                        color: Colors.amber,
                      ),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05), // 5% dari lebar layar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.07, // 7% lebar layar
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02), // 2% tinggi layar
                  
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.04, // 4% lebar layar
                      vertical: MediaQuery.of(context).size.height * 0.01, // 1% tinggi layar
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Rp ${price.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: MediaQuery.of(context).size.width * 0.06, // 6% lebar layar
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03), // 3% tinggi layar
                  
                  Container(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05), // 5% lebar layar
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deskripsi',
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: MediaQuery.of(context).size.width * 0.05, // 5% lebar layar
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01), // 1% tinggi layar
                        Text(
                          description,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: MediaQuery.of(context).size.width * 0.04, // 4% lebar layar
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03), // 3% tinggi layar
                  
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.07, // 7% tinggi layar
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Barang ditambahkan ke keranjang!',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04, // 4% lebar layar
                              ),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: Text(
                        'Beli Sekarang',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.045, // 4.5% lebar layar
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
