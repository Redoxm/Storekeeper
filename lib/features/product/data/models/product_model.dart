import '../../domain/entities/product.dart';
import '../../../../core/constants/database_constants.dart';

/// Product model for data layer
/// Handles conversion between database maps and Product entities
class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.quantity,
    required super.price,
    super.imagePath,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create ProductModel from Product entity
  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      quantity: product.quantity,
      price: product.price,
      imagePath: product.imagePath,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
    );
  }

  /// Create ProductModel from database map
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map[DatabaseConstants.columnId] as String,
      name: map[DatabaseConstants.columnName] as String,
      quantity: map[DatabaseConstants.columnQuantity] as int,
      price: map[DatabaseConstants.columnPrice] as double,
      imagePath: map[DatabaseConstants.columnImagePath] as String?,
      createdAt: DateTime.parse(
        map[DatabaseConstants.columnCreatedAt] as String,
      ),
      updatedAt: DateTime.parse(
        map[DatabaseConstants.columnUpdatedAt] as String,
      ),
    );
  }

  /// Convert ProductModel to database map
  Map<String, dynamic> toMap() {
    return {
      DatabaseConstants.columnId: id,
      DatabaseConstants.columnName: name,
      DatabaseConstants.columnQuantity: quantity,
      DatabaseConstants.columnPrice: price,
      DatabaseConstants.columnImagePath: imagePath,
      DatabaseConstants.columnCreatedAt: createdAt.toIso8601String(),
      DatabaseConstants.columnUpdatedAt: updatedAt.toIso8601String(),
    };
  }

  /// Convert to Product entity
  Product toEntity() {
    return Product(
      id: id,
      name: name,
      quantity: quantity,
      price: price,
      imagePath: imagePath,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, quantity: $quantity, price: $price)';
  }
}
