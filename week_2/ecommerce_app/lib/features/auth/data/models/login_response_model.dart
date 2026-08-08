import 'package:ecommerce_app/features/auth/domain/entities/auth_token.dart';

/// DTO for the POST /auth/login response.
class LoginResponseModel {
  const LoginResponseModel({required this.token});
  final String token;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(token: json['token'] as String);

  /// Convert to domain entity.
  /// userId is set separately (stored at login, decoded from JWT or
  /// hardcoded as 1 for the mock API — see README for details).
  AuthToken toEntity({required int userId}) =>
      AuthToken(token: token, userId: userId);
}
