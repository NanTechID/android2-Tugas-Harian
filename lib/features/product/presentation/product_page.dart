import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/price_formatter.dart';
import '../domain/product_model.dart';
import 'product_notifier.dart';
import '../../../shared/widgets/status_view.dart';

class ProductPage extends ConsumerStatefulWidget {
  const ProductPage({super.key});

  @override
  ConsumerState<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends ConsumerState<ProductPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    Future.microtask(
      () => ref.read(productNotifierProvider.notifier).loadProducts(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productNotifierProvider);
    final notifier = ref.read(productNotifierProvider.notifier);

    Widget content;
    if (state.isLoading) {
      content = const LoadingView();
    } else if (state.error != null) {
      content = ErrorView(
        message: state.error!,
        onRetry: notifier.refreshProducts,
      );
    } else if (state.filteredProducts.isEmpty) {
      content = const Center(child: Text('Tidak ada produk'));
    } else {
      content = RefreshIndicator(
        onRefresh: notifier.refreshProducts,
        child: MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
          itemCount: state.filteredProducts.length,
          itemBuilder: (context, index) {
            final product = state.filteredProducts[index];
            return _ProductCollageCard(
              index: index,
              product: product,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.detail,
                  arguments: product,
                );
              },
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('API Products'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: notifier.search,
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: content,
    );
  }
}

class _ProductCollageCard extends StatelessWidget {
  final int index;
  final Product product;
  final VoidCallback onTap;

  const _ProductCollageCard({
    required this.index,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.image;
    final palette = [
      const Color(0xFFFFF3E8),
      const Color(0xFFE9F7FF),
      const Color(0xFFF1F7E9),
      const Color(0xFFFFECEF),
    ];
    final cardColor = palette[index % palette.length];
    final imageHeights = [150.0, 210.0, 170.0, 230.0];
    final imageHeight = imageHeights[index % imageHeights.length];

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: imageUrl != null && imageUrl.toString().isNotEmpty
                    ? Image.network(
                        imageUrl,
                        height: imageHeight,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: imageHeight,
                          color: Colors.black12,
                          child: Icon(
                            product.icon ?? Icons.image_not_supported,
                            size: 36,
                            color: Colors.black54,
                          ),
                        ),
                      )
                    : Container(
                        height: imageHeight,
                        color: Colors.black12,
                        child: Center(
                          child: Icon(
                            product.icon ?? Icons.shopping_bag,
                            size: 42,
                            color: Colors.black54,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 10),
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Rp ${PriceFormatter.formatPrice(product.price)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF243447),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.description,
                maxLines: index.isEven ? 2 : 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Color(0xFF4D5A69)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
