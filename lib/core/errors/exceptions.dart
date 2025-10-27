/// Custom exceptions for the app
/// These are thrown in the data layer and converted to Failures
library;

class DatabaseException implements Exception {
  final String message;
  const DatabaseException(this.message);

  @override
  String toString() => message;
}

class CacheException implements Exception {
  final String message;
  const CacheException(this.message);

  @override
  String toString() => message;
}

class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);

  @override
  String toString() => message;
}
