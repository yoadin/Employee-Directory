import 'package:ecommerce_app/core/error/error_mapper.dart';
import 'package:ecommerce_app/core/error/exceptions.dart';
import 'package:ecommerce_app/core/error/failures.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/core/utils/result.dart';
import 'package:ecommerce_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:ecommerce_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ecommerce_app/features/auth/domain/entities/auth_token.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remote = remoteDataSource,
       _local = localDataSource,
       _networkInfo = networkInfo;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final NetworkInfo _networkInfo;

  @override
  Future<Result<AuthToken>> login({
    required String username,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      return err(const NetworkFailure());
    }
    try {
      final response = await _remote.login(
        username: username,
        password: password,
      );
      // Fake Store API does not embed userId in JWT.
      // For this mock API we hardcode userId=1 for the documented test user.
      // In a real app, decode the JWT or get userId from a /me endpoint.
      const userId = 1;
      final token = response.toEntity(userId: userId);
      await _local.saveSession(token);
      return ok(token);
    } on NetworkException catch (e) {
      return mapExceptionToFailure(e);
    } on UnauthorizedException catch (e) {
      return mapExceptionToFailure(e);
    } catch (e) {
      return mapExceptionToFailure(e);
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _local.clearSession();
      return ok(null);
    } catch (e) {
      return mapExceptionToFailure(e);
    }
  }

  @override
  Future<AuthToken?> getSavedSession() => _local.getSession();
}
