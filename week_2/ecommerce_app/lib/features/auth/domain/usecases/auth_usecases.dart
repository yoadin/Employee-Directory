import 'package:ecommerce_app/core/utils/result.dart';
import 'package:ecommerce_app/features/auth/domain/entities/auth_token.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';

/// Use case: authenticate user credentials.
class LoginUseCase {
  const LoginUseCase(this._repository);
  final AuthRepository _repository;

  Future<Result<AuthToken>> call({
    required String username,
    required String password,
  }) =>
      _repository.login(username: username, password: password);
}

/// Use case: clear the current session.
class LogoutUseCase {
  const LogoutUseCase(this._repository);
  final AuthRepository _repository;

  Future<Result<void>> call() => _repository.logout();
}
