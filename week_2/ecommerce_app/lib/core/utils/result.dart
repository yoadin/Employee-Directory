// Result<T> — a simple Either-like type for async operations.
// Success wraps a value T; Failure wraps a Failure.
// Using sealed classes so the compiler enforces exhaustive switches.

import 'package:ecommerce_app/core/error/failures.dart';

sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure;

  T? get valueOrNull => switch (this) {
    Success<T>(:final value) => value,
    _ => null,
  };

  Failure? get failureOrNull => switch (this) {
    ResultFailure<T>(:final failure) => failure,
    _ => null,
  };

  /// Run [onSuccess] or [onFailure] depending on the result.
  R when<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) => switch (this) {
    Success<T>(:final value) => onSuccess(value),
    ResultFailure<T>(:final failure) => onFailure(failure),
  };
}

final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

final class ResultFailure<T> extends Result<T> {
  const ResultFailure(this.failure);
  final Failure failure;
}

// Convenience constructors
Result<T> ok<T>(T value) => Success<T>(value);
Result<T> err<T>(Failure failure) => ResultFailure<T>(failure);
