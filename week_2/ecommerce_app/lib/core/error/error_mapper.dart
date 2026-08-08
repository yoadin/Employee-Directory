import 'package:ecommerce_app/core/error/exceptions.dart';
import 'package:ecommerce_app/core/error/failures.dart';
import 'package:ecommerce_app/core/utils/result.dart';

/// Maps an exception thrown by data sources to a [Failure].
/// Call this inside repository catch blocks.
Result<T> mapExceptionToFailure<T>(Object e) {
  return switch (e) {
    NetworkException() => err(NetworkFailure(e.message)),
    UnauthorizedException() => err(AuthFailure(e.message)),
    NotFoundException() => err(NotFoundFailure(e.message)),
    ServerException() => err(ServerFailure.withCode(e.message, e.statusCode)),
    CacheException() => err(CacheFailure(e.message)),
    _ => err(const UnknownFailure()),
  };
}
