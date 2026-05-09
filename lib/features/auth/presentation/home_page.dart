import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:praktikum1/features/product/presentation/product_provider.dart';
import 'package:praktikum1/features/product/domain/product_model.dart';
import 'package:praktikum1/features/product/presentation/product_detail_page.dart';
import 'package:praktikum1/features/product/presentation/product_edit_page.dart';
import 'package:praktikum1/features/praktikum1/widgets_demo_page.dart';
import 'package:praktikum1/features/settings/presentation/settings_page.dart';
import 'package:praktikum1/core/routes/app_routes.dart';
import 'package:praktikum1/core/utils/price_formatter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;
  IconData _selectedIcon = Icons.shopping_bag;
  String _selectedPriceFilter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _addProduct() {
    if (_nameController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      final price = int.tryParse(_priceController.text);
      if (price != null) {
        final newProduct = Product(
          name: _nameController.text,
          price: price,
          description: _descriptionController.text,
          icon: _selectedIcon,
        );
        Provider.of<ProductProvider>(context, listen: false).addProduct(
          newProduct.name,
          newProduct.price,
          newProduct.description,
          _selectedIcon,
        );
        _nameController.clear();
        _priceController.clear();
        _descriptionController.clear();
        _selectedIcon = Icons.shopping_bag;
        Navigator.pop(context);
      }
    }
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Add Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
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
                                      setStateDialog(() {
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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _addProduct,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteProduct(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete ${product.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<ProductProvider>(
                context,
                listen: false,
              ).removeProduct(product);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: product),
      ),
    );
  }

  void _navigateToEditProduct(Product product) async {
    final updatedProduct = await Navigator.push<Product>(
      context,
      MaterialPageRoute(
        builder: (context) => ProductEditPage(product: product),
      ),
    );

    if (!mounted || updatedProduct == null) {
      return;
    }

    Provider.of<ProductProvider>(
      context,
      listen: false,
    ).updateProduct(product, updatedProduct);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product updated successfully')),
    );
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Produk',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Semua'),
                      selected: _selectedPriceFilter == 'all',
                      onSelected: (_) {
                        setState(() => _selectedPriceFilter = 'all');
                        Navigator.pop(context);
                      },
                    ),
                    ChoiceChip(
                      label: const Text('<= 100.000'),
                      selected: _selectedPriceFilter == 'low',
                      onSelected: (_) {
                        setState(() => _selectedPriceFilter = 'low');
                        Navigator.pop(context);
                      },
                    ),
                    ChoiceChip(
                      label: const Text('100.001 - 500.000'),
                      selected: _selectedPriceFilter == 'mid',
                      onSelected: (_) {
                        setState(() => _selectedPriceFilter = 'mid');
                        Navigator.pop(context);
                      },
                    ),
                    ChoiceChip(
                      label: const Text('> 500.000'),
                      selected: _selectedPriceFilter == 'high',
                      onSelected: (_) {
                        setState(() => _selectedPriceFilter = 'high');
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductCollageCard(Product product, int index) {
    final imageUrl = product.image;
    final hasImage = (imageUrl ?? '').trim().isNotEmpty;
    final palette = [
      const Color(0xFFFFF4E5),
      const Color(0xFFE8F6FF),
      const Color(0xFFEAF7EE),
      const Color(0xFFFFEEF2),
    ];
    const imageHeight = 150.0;

    return Card(
      elevation: 0,
      color: palette[index % palette.length],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _navigateToDetail(context, product),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: hasImage
                          ? Image.network(
                              imageUrl!,
                              width: double.infinity,
                              height: imageHeight,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: double.infinity,
                                  height: imageHeight,
                                  color: Colors.black12,
                                  child: Icon(
                                    product.icon ?? Icons.image_not_supported,
                                    color: Colors.black54,
                                    size: 32,
                                  ),
                                );
                              },
                            )
                          : Container(
                              width: double.infinity,
                              height: imageHeight,
                              color: Colors.black12,
                              child: Icon(
                                product.icon ?? Icons.shopping_bag,
                                color: Colors.black54,
                                size: 34,
                              ),
                            ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rp ${PriceFormatter.formatPrice(product.price)}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0066CC),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[600],
                        height: 1.25,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -4,
                right: -4,
                child: PopupMenuButton<String>(
                  icon: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(Icons.more_horiz, size: 18),
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      _navigateToEditProduct(product);
                    } else if (value == 'delete') {
                      _deleteProduct(context, product);
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.blue, size: 18),
                          SizedBox(width: 8),
                          Text('Edit', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 18),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductsPage() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(14, 14, 14, 8),
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A0E2D4C),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F2742), Color(0xFF1E9E9B)],
                      ),
                    ),
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Discover Products',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF142A43),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Cari, filter, dan kelola produk lebih cepat.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF55708A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.icon(
                    onPressed: _showFilterOptions,
                    icon: const Icon(Icons.tune_rounded),
                    label: const Text('Filter'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0F2742),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Consumer<ProductProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text('Loading products...'),
                    ],
                  ),
                );
              }
              final filteredProducts = provider.products.where((product) {
                final matchesName = product.name.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                );

                bool matchesPrice;
                switch (_selectedPriceFilter) {
                  case 'low':
                    matchesPrice = product.price <= 100000;
                    break;
                  case 'mid':
                    matchesPrice =
                        product.price > 100000 && product.price <= 500000;
                    break;
                  case 'high':
                    matchesPrice = product.price > 500000;
                    break;
                  default:
                    matchesPrice = true;
                }

                return matchesName && matchesPrice;
              }).toList();
              if (filteredProducts.isEmpty) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 46,
                          color: Color(0xFF607D94),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Coba ubah kata kunci pencarian atau filter harga.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return MasonryGridView.builder(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return _buildProductCollageCard(product, index);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_selectedIndex == 0 ? 'Product List' : 'Praktikum Apps'),
            Text(
              _selectedIndex == 0
                  ? 'Kelola produk dengan mudah'
                  : 'Atur preferensi aplikasi',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        toolbarHeight: 72,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0F2742), Color(0xFF1E9E9B)],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
          IconButton(
            icon: const Icon(Icons.widgets),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WidgetsDemoPage(),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              backgroundColor: const Color(0xFF0F2742),
              foregroundColor: Colors.white,
              elevation: 8,
              extendedPadding: const EdgeInsets.symmetric(horizontal: 18),
              onPressed: _showAddProductDialog,
              icon: const Icon(Icons.add_circle_outline, size: 22),
              label: const Text(
                'add product',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: _selectedIndex == 0 ? _buildProductsPage() : const SettingsPage(),
      bottomNavigationBar: NavigationBar(
        height: 72,
        backgroundColor: Colors.white,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onNavItemTapped,
        indicatorColor: const Color(0xFFE6F2FF),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
