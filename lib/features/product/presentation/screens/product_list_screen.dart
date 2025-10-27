// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/product_provider.dart';
import '../providers/product_state.dart';
import '../../domain/entities/product.dart';
import '../widgets/product_card.dart';
import '../widgets/inventory_pie_chart.dart';
import 'add_product_screen.dart';
import 'edit_product_screen.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  late AnimationController _fabAnimationController;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Load products when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productNotifierProvider.notifier).loadProducts();
      _fabAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      ref.read(productNotifierProvider.notifier).loadProducts();
    } else {
      ref.read(productNotifierProvider.notifier).searchProductsByName(query);
    }
  }

  Future<void> _onRefresh() async {
    await ref.read(productNotifierProvider.notifier).loadProducts();
  }

  void _navigateToAddProduct() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddProductScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _navigateToEditProduct(Product product) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            EditProductScreen(product: product),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  Future<void> _confirmDelete(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => FadeIn(
        duration: const Duration(milliseconds: 200),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Delete Product'),
          content: Text('Are you sure you want to delete "${product.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true && mounted) {
      await ref
          .read(productNotifierProvider.notifier)
          .deleteExistingProduct(product.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productNotifierProvider);

    // Listen to state changes for snackbar messages
    ref.listen<ProductState>(productNotifierProvider, (previous, next) {
      if (next is ProductOperationSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(next.message)),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      } else if (next is ProductError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(next.message)),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search products...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: _onSearchChanged,
              )
            : const Text('Storekeeper'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  ref.read(productNotifierProvider.notifier).loadProducts();
                }
              });
            },
          ),
        ],
      ),
      body: _buildBody(productState),
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(
          parent: _fabAnimationController,
          curve: Curves.elasticOut,
        ),
        child: FloatingActionButton.extended(
          onPressed: _navigateToAddProduct,
          icon: const Icon(Icons.add),
          label: const Text('Add Product'),
          backgroundColor: Colors.blue.shade700,
        ),
      ),
    );
  }

  Widget _buildBody(ProductState state) {
    if (state is ProductLoading) {
      return _buildLoadingState();
    }

    if (state is ProductEmpty) {
      return _buildEmptyState();
    }

    if (state is ProductsLoaded) {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        color: Colors.blue.shade700,
        child: _buildProductList(state.products),
      );
    }

    if (state is ProductError) {
      return _buildErrorState(state.message);
    }

    // Initial state
    return _buildEmptyState();
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinPerfect(
            infinite: true,
            duration: const Duration(seconds: 2),
            child: Icon(
              Icons.inventory_2_rounded,
              size: 64,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading products...',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(List<Product> products) {
    // Calculate statistics
    final totalValue = products.fold<double>(
      0,
      (sum, product) => sum + product.totalValue,
    );

    final totalItems = products.fold<int>(
      0,
      (sum, product) => sum + product.quantity,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary Cards Row
        FadeInDown(
          duration: const Duration(milliseconds: 600),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Value',
                  NumberFormat.currency(symbol: '₦').format(totalValue),
                  Icons.monetization_on,
                  Colors.green.shade600,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Total Items',
                  totalItems.toString(),
                  Icons.inventory,
                  Colors.blue.shade600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Products Count Card
        FadeInDown(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 100),
          child: _buildStatCard(
            'Products',
            '${products.length}',
            Icons.shopping_bag,
            Colors.purple,
            isFullWidth: true,
          ),
        ),

        const SizedBox(height: 16),

        // Pie Chart
        FadeInUp(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 200),
          child: InventoryPieChart(products: products),
        ),

        const SizedBox(height: 24),

        // Products List Header
        FadeInLeft(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 300),
          child: Row(
            children: [
              Icon(Icons.list_alt, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              const Text(
                'All Products',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Product Cards
        ...products.asMap().entries.map((entry) {
          final index = entry.key;
          final product = entry.value;
          return FadeInUp(
            duration: const Duration(milliseconds: 400),
            delay: Duration(milliseconds: 400 + (index * 50)),
            child: ProductCard(
              product: product,
              onTap: () => _navigateToEditProduct(product),
              onDelete: () => _confirmDelete(product),
            ),
          );
          // ignore: unnecessary_to_list_in_spreads
        }).toList(),

        const SizedBox(height: 80), // Space for FAB
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color, {
    bool isFullWidth = false,
  }) {
    // Create a proper gradient with MaterialColor or specific shades
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Use solid colors instead of gradient if gradient is causing issues
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              if (!isFullWidth)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.trending_up,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 800),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 120,
              color: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 24),
          FadeInUp(
            duration: const Duration(milliseconds: 800),
            delay: const Duration(milliseconds: 200),
            child: Text(
              'No products yet',
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          FadeInUp(
            duration: const Duration(milliseconds: 800),
            delay: const Duration(milliseconds: 400),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'Start building your inventory by adding your first product',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                  height: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          FadeInUp(
            duration: const Duration(milliseconds: 800),
            delay: const Duration(milliseconds: 600),
            child: ElevatedButton.icon(
              onPressed: _navigateToAddProduct,
              icon: const Icon(Icons.add),
              label: const Text('Add Your First Product'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElasticIn(
            duration: const Duration(milliseconds: 800),
            child: Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(productNotifierProvider.notifier).loadProducts();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
