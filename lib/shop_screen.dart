import 'package:flutter/material.dart';
import 'db_helper.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  List<Map<String, dynamic>> _products = [];

  // Memuat produk dari database
  void _loadProducts() async {
    final data = await DBHelper.getProducts();
    setState(() {
      _products = data;
    });
  }

  // Menampilkan dialog untuk menambahkan atau mengedit produk
  void _showProductDialog({Map<String, dynamic>? product}) {
    final TextEditingController nameController = TextEditingController(
      text: product?['name'] ?? '',
    );
    final TextEditingController descriptionController = TextEditingController(
      text: product?['description'] ?? '',
    );
    final TextEditingController priceController = TextEditingController(
      text: product?['price']?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(product == null ? 'Add Product' : 'Edit Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty ||
                  descriptionController.text.isEmpty ||
                  priceController.text.isEmpty) {
                return;
              }

              final newProduct = {
                'name': nameController.text,
                'description': descriptionController.text,
                'price': double.tryParse(priceController.text) ?? 0.0,
              };

              if (product == null) {
                await DBHelper.insertProduct(newProduct);
              } else {
                await DBHelper.updateProduct(product['id'], newProduct);
              }

              _loadProducts();
              Navigator.pop(ctx);
            },
            child: Text(product == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  // Menghapus produk
  void _deleteProduct(int id) async {
    await DBHelper.deleteProduct(id);
    _loadProducts();
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Management'),
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (ctx, index) {
          final product = _products[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(product['name']),
              subtitle: Text('Price: \$${product['price']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showProductDialog(product: product),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteProduct(product['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
