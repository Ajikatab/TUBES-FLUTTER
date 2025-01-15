import 'package:flutter/material.dart';
import 'detail_merch.dart';

class ShopPelangganScreen extends StatefulWidget {
  const ShopPelangganScreen({super.key});

  @override
  _ShopPelangganScreenState createState() => _ShopPelangganScreenState();
}

class _ShopPelangganScreenState extends State<ShopPelangganScreen> {
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Product 1',
      'description': 'Description of Product 1',
      'price': 100000,
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Product 2',
      'description': 'Description of Product 2',
      'price': 150000,
      'imageUrl': 'https://via.placeholder.com/150',
    },
  ];
  final int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(
          'Cinema Merchandise',
          style: TextStyle(
            color: Colors.grey[300],
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _products.length,
        itemBuilder: (ctx, index) {
          final product = _products[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailMerchScreen(
                    name: product['name'],
                    description: product['description'],
                    price: product['price'],
                    imageUrl: product['imageUrl'],
                  ),
                ),
              );
            },
            child: Card(
              elevation: 8,
              color: const Color(0xFF2C2C2C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.movie_filter,
                        size: 50,
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'],
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${product['price'].toStringAsFixed(0)}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Text(
                              product['description'] ?? '',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  size: 16,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'View Details',
                                  style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Now Showing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            // Halaman ini sudah aktif
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/about');
          }
        },
      ),
    );
  }
}
