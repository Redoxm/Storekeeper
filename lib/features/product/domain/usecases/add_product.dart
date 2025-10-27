import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/validators.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Use case for adding a new product
class AddProduct implements UseCase<Product, AddProductParams> {
  final ProductRepository repository;

  AddProduct(this.repository);

  @override
  Future<Either<Failure, Product>> call(AddProductParams params) async {
    // Validate inputs before proceeding
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

    // Create product entity
    final now = DateTime.now();
    final product = Product(
      id: params.id,
      name: params.name.trim(),
      quantity: params.quantity,
      price: params.price,
      imagePath: params.imagePath,
      createdAt: now,
      updatedAt: now,
    );

    // Add to repository
    return await repository.addProduct(product);
  }
}

/// Parameters for adding a product
class AddProductParams extends Equatable {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String? imagePath;

  const AddProductParams({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.imagePath,
  });

  @override
  List<Object?> get props => [id, name, quantity, price, imagePath];
}
