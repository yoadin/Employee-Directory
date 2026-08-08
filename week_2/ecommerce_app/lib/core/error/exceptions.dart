// Custom exception types thrown by data sources.
// These are mapped to Failure objects by the repository layer.

class ServerException implements Exception {
  const ServerException({this.message = 'Server error', this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => 'ServerException($statusCode): $message';
}

class UnauthorizedException implements Exception {
  const UnauthorizedException({this.message = 'Unauthorized'});
  final String message;

  @override
  String toString() => 'UnauthorizedException: $message';
}

class NetworkException implements Exception {
  const NetworkException({this.message = 'No internet connection'});
  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  const CacheException({this.message = 'Cache error'});
  final String message;

  @override
  String toString() => 'CacheException: $message';
}

class NotFoundException implements Exception {
  const NotFoundException({this.message = 'Resource not found'});
  final String message;

  @override
  String toString() => 'NotFoundException: $message';
}
