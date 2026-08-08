import 'package:ecommerce_app/core/error/error_mapper.dart';
import 'package:ecommerce_app/core/error/failures.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/core/utils/result.dart';
import 'package:ecommerce_app/features/categories/data/datasources/category_remote_datasource.dart';
import 'package:ecommerce_app/features/categories/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl({
    required CategoryRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remote = remoteDataSource,
       _networkInfo = networkInfo;

  final CategoryRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Result<List<String>>> getCategories() async {
    if (!await _networkInfo.isConnected) {
      return err(const NetworkFailure());
    }
    try {
      final categories = await _remote.getCategories();
      return ok(categories);
    } catch (e) {
      return mapExceptionToFailure(e);
    }
  }
}
