import 'package:flutter/material.dart';

class Product {
  final int? id;
  final String name;
  final num price;
  final String description;
  final String? image;
  final IconData? icon;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    this.image,
    this.icon,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawPrice = json['price'];
    final parsedPrice = rawPrice is num
        ? rawPrice
        : num.tryParse(rawPrice?.toString() ?? '0') ?? 0;

    return Product(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()),
      name: (json['title'] ?? json['name'])?.toString() ?? '',
      price: parsedPrice,
      description: (json['description'] ?? json['desc'])?.toString() ?? '',
      image: json['image']?.toString(),
      icon: Icons.shopping_bag,
    );
  }

  @override
  String toString() =>
      'Product(id: $id, name: $name, price: $price, description: $description, image: $image, icon: $icon)';
}
