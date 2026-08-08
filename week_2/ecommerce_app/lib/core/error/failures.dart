// Sealed Failure hierarchy — domain-level error representation.
// Data layer maps exceptions -> Failures; presentation layer consumes Failures.

sealed class Failure {
  const Failure(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Network connectivity failure (no internet).
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

/// HTTP server failure (4xx/5xx responses other than 401).
final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error']) : statusCode = null;
  const ServerFailure.withCode(super.message, this.statusCode);
  final int? statusCode;
}

/// Authentication failure (401 / bad credentials).
final class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}

/// Local cache / Hive failure.
final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local storage error']);
}

/// Resource not found (404).
final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

/// Unexpected / unknown failure.
final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred']);
}
