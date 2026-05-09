import 'package:flutter/foundation.dart';
import '../domain/product_model.dart';

class HomeViewModel extends ChangeNotifier {
  final List<Product> _products = [
    Product(
      name: "Laptop",
      price: 10000000,
      description: "High-performance gaming laptop",
    ),
    Product(
      name: "Mouse",
      price: 200000,
      description: "Wireless optical mouse",
    ),
    Product(
      name: "Keyboard",
      price: 500000,
      description: "Mechanical gaming keyboard",
    ),
  ];

  final ValueNotifier<List<Product>> productsNotifier = ValueNotifier([]);

  HomeViewModel() {
    productsNotifier.value = List.unmodifiable(_products);
  }

  List<Product> get products => List.unmodifiable(_products);

  Future<List<Product>> getProductsAsync() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return products;
  }

  void addProduct(Product product) {
    _products.add(product);
    productsNotifier.value = List.unmodifiable(_products);
    notifyListeners();
  }
}
