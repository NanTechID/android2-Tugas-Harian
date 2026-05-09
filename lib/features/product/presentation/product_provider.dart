import 'package:flutter/material.dart';
import '../domain/product_model.dart';
import '../data/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _service = ProductService();

  bool _isLoading = false;
  String? _error;
  final List<Product> _products = [];

  List<Product> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  String? get error => _error;

  void addProduct(
    String name,
    num price,
    String description, [
    IconData icon = Icons.shopping_bag,
  ]) {
    _products.add(
      Product(
        name: name,
        price: price.toDouble(),
        description: description,
        icon: icon,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiProducts = await _service.getProducts();
      _products
        ..clear()
        ..addAll(apiProducts);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void removeProduct(Product product) {
    _products.remove(product);
    notifyListeners();
  }

  void updateProduct(Product oldProduct, Product newProduct) {
    final index = _products.indexOf(oldProduct);
    if (index != -1) {
      _products[index] = newProduct;
      notifyListeners();
    }
  }
}
