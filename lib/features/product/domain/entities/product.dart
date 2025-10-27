import 'package:equatable/equatable.dart';

/// Product entity - represents a product in our business logic
/// This is a pure Dart class with no dependencies on frameworks
class Product extends Equatable {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String? imagePath;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calculate total value of this product (quantity * price)
  double get totalValue => quantity * price;

  /// Check if product has an image
  bool get hasImage => imagePath != null && imagePath!.isNotEmpty;

  /// Copy method for creating modified versions of product
  Product copyWith({
    String? id,
    String? name,
    int? quantity,
    double? price,
    String? imagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    quantity,
    price,
    imagePath,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'Product(id: $id, name: $name, quantity: $quantity, price: $price)';
  }
}
