import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

/// Represents the state of product operations
/// Using sealed classes pattern for exhaustive checking
abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

/// Initial state - nothing has happened yet
class ProductInitial extends ProductState {
  const ProductInitial();
}

/// Loading state - operation in progress
class ProductLoading extends ProductState {
  const ProductLoading();
}

/// Success state - products loaded successfully
class ProductsLoaded extends ProductState {
  final List<Product> products;

  const ProductsLoaded(this.products);

  @override
  List<Object> get props => [products];
}

/// Success state - single product loaded
class ProductLoaded extends ProductState {
  final Product product;

  const ProductLoaded(this.product);

  @override
  List<Object> get props => [product];
}

/// Success state - operation completed successfully
class ProductOperationSuccess extends ProductState {
  final String message;

  const ProductOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

/// Error state - operation failed
class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}

/// Empty state - no products found
class ProductEmpty extends ProductState {
  const ProductEmpty();
}
