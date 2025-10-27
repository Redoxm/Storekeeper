import 'package:equatable/equatable.dart';

/// Base class for all failures in the app
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => message;
}

/// Thrown when database operations fail
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

/// Thrown when file/image operations fail
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Thrown when input validation fails
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Thrown when permissions are denied
class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}
