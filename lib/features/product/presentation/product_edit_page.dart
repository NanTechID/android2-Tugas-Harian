import 'package:flutter/material.dart';
import 'package:praktikum1/features/product/domain/product_model.dart';

class ProductEditPage extends StatefulWidget {
  final Product product;

  const ProductEditPage({super.key, required this.product});

  @override
  State<ProductEditPage> createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late IconData _selectedIcon;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    _descriptionController = TextEditingController(
      text: widget.product.description,
    );
    _selectedIcon = widget.product.icon ?? Icons.shopping_bag;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_nameController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      final price = int.tryParse(_priceController.text);
      if (price != null) {
        final updatedProduct = Product(
          name: _nameController.text,
          price: price,
          description: _descriptionController.text,
          icon: _selectedIcon,
        );
        Navigator.pop(context, updatedProduct);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Select Icon:'),
                SizedBox(
                  width: 200,
                  child: Wrap(
                    spacing: 8,
                    children:
                        [
                              Icons.shopping_bag,
                              Icons.laptop,
                              Icons.mouse,
                              Icons.keyboard,
                              Icons.book,
                              Icons.camera,
                              Icons.headphones,
                              Icons.watch,
                            ]
                            .map(
                              (icon) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedIcon = icon;
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: _selectedIcon == icon
                                      ? Colors.blue
                                      : Colors.grey[300],
                                  child: Icon(
                                    icon,
                                    color: _selectedIcon == icon
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
