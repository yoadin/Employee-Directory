import 'package:ecommerce_app/core/error/error_mapper.dart';
import 'package:ecommerce_app/core/error/failures.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/core/utils/result.dart';
import 'package:ecommerce_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:ecommerce_app/features/profile/domain/entities/user_profile.dart';
import 'package:ecommerce_app/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remote = remoteDataSource,
       _networkInfo = networkInfo;

  final ProfileRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Result<UserProfile>> getProfile(int userId) async {
    if (!await _networkInfo.isConnected) {
      return err(const NetworkFailure());
    }
    try {
      final model = await _remote.getProfile(userId);
      return ok(model.toEntity());
    } catch (e) {
      return mapExceptionToFailure(e);
    }
  }
}
