import 'package:ecommerce_app/core/error/exceptions.dart';
import 'package:ecommerce_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:ecommerce_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:ecommerce_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:ecommerce_app/features/profile/domain/entities/user_profile.dart';
import 'package:ecommerce_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:ecommerce_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>(
  (ref) => ProfileRemoteDataSourceImpl(ref.watch(authedDioProvider)),
);

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(
    remoteDataSource: ref.watch(profileRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  ),
);

final getProfileUseCaseProvider = Provider<GetProfileUseCase>(
  (ref) => GetProfileUseCase(ref.watch(profileRepositoryProvider)),
);

final profileProvider = FutureProvider<UserProfile>((ref) async {
  final token = ref.watch(authTokenProvider);
  if (token == null) throw const UnauthorizedException();
  final useCase = ref.watch(getProfileUseCaseProvider);
  final result = await useCase(token.userId);
  return result.when(onSuccess: (p) => p, onFailure: (f) => throw f);
});
