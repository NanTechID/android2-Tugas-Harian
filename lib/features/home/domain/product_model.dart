class Product {
  final String name;
  final int price;
  final String description;

  Product({required this.name, required this.price, required this.description});

  @override
  String toString() =>
      'Product(name: $name, price: $price, description: $description)';
}
