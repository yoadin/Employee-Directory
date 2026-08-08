import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/error/exceptions.dart';
import 'package:ecommerce_app/features/profile/data/models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getProfile(int userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  const ProfileRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<UserProfileModel> getProfile(int userId) async {
    try {
      final response =
          await _dio.get<Map<String, dynamic>>('/users/$userId');
      final data = response.data;
      if (data == null) throw const NotFoundException();
      return UserProfileModel.fromJson(data);
    } on DioException catch (e) {
      final inner = e.error;
      if (inner is NetworkException) throw inner;
      if (inner is UnauthorizedException) throw inner;
      if (inner is NotFoundException) throw inner;
      throw ServerException(message: e.message ?? 'Failed to load profile');
    }
  }
}
