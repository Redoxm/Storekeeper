import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Base class for all use cases in the app
/// Type: The return type of the use case
/// Params: The parameters needed for the use case
// ignore: avoid_types_as_parameter_names
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Used when a use case doesn't need any parameters
class NoParams {
  const NoParams();
}
