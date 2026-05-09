import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/product_service.dart';
import '../domain/product_model.dart';

class ProductState {
  final bool isLoading;
  final String? error;
  final List<Product> products;
  final List<Product> filteredProducts;
  final String searchQuery;

  const ProductState({
    this.isLoading = false,
    this.error,
    this.products = const [],
    this.filteredProducts = const [],
    this.searchQuery = '',
  });

  static const _undefined = Object();

  ProductState copyWith({
    bool? isLoading,
    Object? error = _undefined,
    List<Product>? products,
    List<Product>? filteredProducts,
    String? searchQuery,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      error: error == _undefined ? this.error : error as String?,
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductService _service;

  ProductNotifier([ProductService? service])
    : _service = service ?? ProductService(),
      super(const ProductState());

  Future<void> loadProducts({bool forceRefresh = false}) async {
    if (!forceRefresh && state.products.isNotEmpty) {
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final products = await _service.getProducts();
      state = state.copyWith(
        isLoading: false,
        error: null,
        products: products,
        filteredProducts: products,
        searchQuery: '',
      );
    } on Exception catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refreshProducts() async {
    await loadProducts(forceRefresh: true);
  }

  void search(String query) {
    final lowerQuery = query.toLowerCase();
    final filtered = query.isEmpty
        ? state.products
        : state.products
              .where(
                (product) => product.name.toLowerCase().contains(lowerQuery),
              )
              .toList();

    state = state.copyWith(filteredProducts: filtered, searchQuery: query);
  }
}

final productNotifierProvider =
    StateNotifierProvider<ProductNotifier, ProductState>(
      (ref) => ProductNotifier(),
    );
