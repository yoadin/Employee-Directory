import 'package:ecommerce_app/core/utils/result.dart';
import 'package:ecommerce_app/features/profile/domain/entities/user_profile.dart';
import 'package:ecommerce_app/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  const GetProfileUseCase(this._repository);
  final ProfileRepository _repository;

  Future<Result<UserProfile>> call(int userId) => _repository.getProfile(userId);
}
