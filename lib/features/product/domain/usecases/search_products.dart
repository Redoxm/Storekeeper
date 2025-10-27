import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Use case for searching products by name
class SearchProducts implements UseCase<List<Product>, SearchProductsParams> {
  final ProductRepository repository;

  SearchProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(
    SearchProductsParams params,
  ) async {
    if (params.query.trim().isEmpty) {
      return const Left(ValidationFailure('Search query cannot be empty'));
    }

    return await repository.searchProducts(params.query.trim());
  }
}

/// Parameters for searching products
class SearchProductsParams extends Equatable {
  final String query;

  const SearchProductsParams({required this.query});

  @override
  List<Object> get props => [query];
}
