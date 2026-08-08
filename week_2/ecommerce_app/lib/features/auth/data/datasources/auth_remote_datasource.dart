import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/error/exceptions.dart';
import 'package:ecommerce_app/features/auth/data/models/login_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String username,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<LoginResponseModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'username': username, 'password': password},
      );
      final body = response.data;
      if (body == null) throw const ServerException(message: 'Empty response body');
      return LoginResponseModel.fromJson(body);
    } on DioException catch (e) {
      final inner = e.error;
      if (inner is NetworkException) throw inner;
      if (inner is UnauthorizedException) throw inner;
      if (inner is ServerException) throw inner;
      // Fake Store API returns 200 with a non-token body for bad credentials.
      throw ServerException(message: e.message ?? 'Login failed');
    }
  }
}
