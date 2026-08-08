import 'package:ecommerce_app/core/utils/result.dart';
import 'package:ecommerce_app/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRepository {
  Future<Result<UserProfile>> getProfile(int userId);
}
