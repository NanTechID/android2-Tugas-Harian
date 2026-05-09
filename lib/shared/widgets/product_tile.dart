import 'package:flutter/material.dart';
import '../../features/product/domain/product_model.dart';
import 'package:praktikum1/core/utils/price_formatter.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductTile({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: product.image != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.image!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported),
              ),
            )
          : CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Icon(
                product.icon ?? Icons.shopping_bag,
                color: Colors.blue,
              ),
            ),
      title: Text(product.name),
      subtitle: Text('Rp ${PriceFormatter.formatPrice(product.price)}'),
      onTap: onTap,
    );
  }
}
