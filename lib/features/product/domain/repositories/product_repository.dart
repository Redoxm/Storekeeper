import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';

/// Contract for product data operations
/// This interface defines what operations are available
/// The actual implementation is in the data layer
abstract class ProductRepository {
  /// Get all products from database
  Future<Either<Failure, List<Product>>> getAllProducts();

  /// Get a single product by ID
  Future<Either<Failure, Product>> getProductById(String id);

  /// Add a new product
  Future<Either<Failure, Product>> addProduct(Product product);

  /// Update an existing product
  Future<Either<Failure, Product>> updateProduct(Product product);

  /// Delete a product by ID
  Future<Either<Failure, bool>> deleteProduct(String id);

  /// Search products by name
  Future<Either<Failure, List<Product>>> searchProducts(String query);
}
