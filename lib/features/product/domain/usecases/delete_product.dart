import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/product_repository.dart';

/// Use case for deleting a product
class DeleteProduct implements UseCase<bool, DeleteProductParams> {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  @override
  Future<Either<Failure, bool>> call(DeleteProductParams params) async {
    if (params.id.trim().isEmpty) {
      return const Left(ValidationFailure('Product ID cannot be empty'));
    }

    return await repository.deleteProduct(params.id);
  }
}

/// Parameters for deleting a product
class DeleteProductParams extends Equatable {
  final String id;

  const DeleteProductParams({required this.id});

  @override
  List<Object> get props => [id];
}
