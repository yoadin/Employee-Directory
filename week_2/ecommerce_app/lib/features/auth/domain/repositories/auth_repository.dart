import 'package:ecommerce_app/core/utils/result.dart';
import 'package:ecommerce_app/features/auth/domain/entities/auth_token.dart';

/// Abstract auth repository — implemented in the data layer.
abstract class AuthRepository {
  /// Authenticate with [username] and [password].
  /// Returns [AuthToken] on success or a [Failure] on error.
  Future<Result<AuthToken>> login({
    required String username,
    required String password,
  });

  /// Clear persisted session data.
  Future<Result<void>> logout();

  /// Returns saved [AuthToken] if a valid session exists, else null.
  Future<AuthToken?> getSavedSession();
}
