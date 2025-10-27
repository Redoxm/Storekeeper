import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/validators.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Use case for updating an existing product
class UpdateProduct implements UseCase<Product, UpdateProductParams> {
  final ProductRepository repository;

  UpdateProduct(this.repository);

  @override
  Future<Either<Failure, Product>> call(UpdateProductParams params) async {
    // Validate inputs
    final nameValidation = Validators.validateProductName(params.name);
    if (nameValidation != null) {
      return Left(ValidationFailure(nameValidation));
    }

    final quantityValidation = Validators.validateQuantity(
      params.quantity.toString(),
    );
    if (quantityValidation != null) {
      return Left(ValidationFailure(quantityValidation));
    }

    final priceValidation = Validators.validatePrice(params.price.toString());
    if (priceValidation != null) {
      return Left(ValidationFailure(priceValidation));
    }

    // Create updated product
    final updatedProduct = Product(
      id: params.id,
      name: params.name.trim(),
      quantity: params.quantity,
      price: params.price,
      imagePath: params.imagePath,
      createdAt: params.createdAt,
      updatedAt: DateTime.now(), // Update timestamp
    );

    return await repository.updateProduct(updatedProduct);
  }
}

/// Parameters for updating a product
class UpdateProductParams extends Equatable {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String? imagePath;
  final DateTime createdAt;

  const UpdateProductParams({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.imagePath,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, quantity, price, imagePath, createdAt];
}
