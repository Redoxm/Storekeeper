import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:storekeeper_app/features/product/domain/usecases/get_products.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/add_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/search_products.dart';
import '../../domain/usecases/update_product.dart';
import '../../data/datasources/product_local_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import 'product_state.dart';

/// Provider for ProductLocalDataSource
final productLocalDataSourceProvider = Provider<ProductLocalDataSource>((ref) {
  return ProductLocalDataSourceImpl();
});

/// Provider for ProductRepository
final productRepositoryProvider = Provider((ref) {
  final dataSource = ref.watch(productLocalDataSourceProvider);
  return ProductRepositoryImpl(localDataSource: dataSource);
});

/// Provider for GetAllProducts use case
final getAllProductsProvider = Provider((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetAllProducts(repository);
});

/// Provider for AddProduct use case
final addProductProvider = Provider((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return AddProduct(repository);
});

/// Provider for UpdateProduct use case
final updateProductProvider = Provider((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return UpdateProduct(repository);
});

/// Provider for DeleteProduct use case
final deleteProductProvider = Provider((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return DeleteProduct(repository);
});

/// Provider for SearchProducts use case
final searchProductsProvider = Provider((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return SearchProducts(repository);
});

/// Main StateNotifier for managing product state
class ProductNotifier extends StateNotifier<ProductState> {
  final GetAllProducts getAllProducts;
  final AddProduct addProduct;
  final UpdateProduct updateProduct;
  final DeleteProduct deleteProduct;
  final SearchProducts searchProducts;

  ProductNotifier({
    required this.getAllProducts,
    required this.addProduct,
    required this.updateProduct,
    required this.deleteProduct,
    required this.searchProducts,
  }) : super(const ProductInitial());

  /// Load all products from database
  Future<void> loadProducts() async {
    state = const ProductLoading();

    final result = await getAllProducts(const NoParams());

    result.fold((failure) => state = ProductError(failure.message), (products) {
      if (products.isEmpty) {
        state = const ProductEmpty();
      } else {
        state = ProductsLoaded(products);
      }
    });
  }

  /// Add a new product
  Future<void> addNewProduct({
    required String name,
    required int quantity,
    required double price,
    String? imagePath,
  }) async {
    state = const ProductLoading();

    // Generate unique ID
    const uuid = Uuid();
    final id = uuid.v4();

    final params = AddProductParams(
      id: id,
      name: name,
      quantity: quantity,
      price: price,
      imagePath: imagePath,
    );

    final result = await addProduct(params);

    result.fold((failure) => state = ProductError(failure.message), (product) {
      state = const ProductOperationSuccess('Product added successfully');
      // Reload products to update the list
      loadProducts();
    });
  }

  /// Update an existing product
  Future<void> updateExistingProduct({
    required String id,
    required String name,
    required int quantity,
    required double price,
    String? imagePath,
    required DateTime createdAt,
  }) async {
    state = const ProductLoading();

    final params = UpdateProductParams(
      id: id,
      name: name,
      quantity: quantity,
      price: price,
      imagePath: imagePath,
      createdAt: createdAt,
    );

    final result = await updateProduct(params);

    result.fold((failure) => state = ProductError(failure.message), (product) {
      state = const ProductOperationSuccess('Product updated successfully');
      // Reload products to update the list
      loadProducts();
    });
  }

  /// Delete a product
  Future<void> deleteExistingProduct(String id) async {
    state = const ProductLoading();

    final params = DeleteProductParams(id: id);

    final result = await deleteProduct(params);

    result.fold((failure) => state = ProductError(failure.message), (success) {
      state = const ProductOperationSuccess('Product deleted successfully');
      // Reload products to update the list
      loadProducts();
    });
  }

  /// Search products by name
  Future<void> searchProductsByName(String query) async {
    if (query.trim().isEmpty) {
      loadProducts();
      return;
    }

    state = const ProductLoading();

    final params = SearchProductsParams(query: query);

    final result = await searchProducts(params);

    result.fold((failure) => state = ProductError(failure.message), (products) {
      if (products.isEmpty) {
        state = const ProductEmpty();
      } else {
        state = ProductsLoaded(products);
      }
    });
  }

  /// Reset state to initial
  void resetState() {
    state = const ProductInitial();
  }
}

/// Provider for ProductNotifier
final productNotifierProvider =
    StateNotifierProvider<ProductNotifier, ProductState>((ref) {
      return ProductNotifier(
        getAllProducts: ref.watch(getAllProductsProvider),
        addProduct: ref.watch(addProductProvider),
        updateProduct: ref.watch(updateProductProvider),
        deleteProduct: ref.watch(deleteProductProvider),
        searchProducts: ref.watch(searchProductsProvider),
      );
    });
