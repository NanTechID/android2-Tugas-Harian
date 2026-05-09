import 'package:flutter/material.dart';
import '../domain/product_model.dart';

class DetailPage extends StatelessWidget {
  final Product product;

  const DetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.image != null)
              Center(
                child: Image.network(
                  product.image!,
                  height: 220,
                  fit: BoxFit.contain,
                ),
              )
            else
              const SizedBox.shrink(),
            const SizedBox(height: 16),
            Text(product.name, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            Text('Harga: Rp ${product.price}'),
            const SizedBox(height: 10),
            Text(product.description),
          ],
        ),
      ),
    );
  }
}
