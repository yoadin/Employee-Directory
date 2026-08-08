import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/network/dio_client.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:ecommerce_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ecommerce_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ecommerce_app/features/auth/domain/entities/auth_token.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/auth_usecases.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Infrastructure ───────────────────────────────────────────────────────────

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Override in main() with SharedPreferences.getInstance()');
});

final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

final networkInfoProvider = Provider<NetworkInfo>((ref) =>
    NetworkInfoImpl(ref.watch(connectivityProvider)));

// Dio without auth (used for login)
final dioProvider = Provider<Dio>((ref) => createDioClient());

// Auth-aware Dio (injects token header after login)
final authedDioProvider = Provider<Dio>((ref) {
  final token = ref.watch(authTokenProvider);
  return createDioClient(authToken: token?.token);
});

// ─── Auth data sources & repository ──────────────────────────────────────────

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) =>
    AuthRemoteDataSourceImpl(ref.watch(dioProvider)));

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) =>
    AuthLocalDataSourceImpl(ref.watch(sharedPreferencesProvider)));

final authRepositoryProvider = Provider<AuthRepository>((ref) =>
    AuthRepositoryImpl(
      remoteDataSource: ref.watch(authRemoteDataSourceProvider),
      localDataSource: ref.watch(authLocalDataSourceProvider),
      networkInfo: ref.watch(networkInfoProvider),
    ));

// ─── Auth use cases ───────────────────────────────────────────────────────────

final loginUseCaseProvider = Provider<LoginUseCase>((ref) =>
    LoginUseCase(ref.watch(authRepositoryProvider)));

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) =>
    LogoutUseCase(ref.watch(authRepositoryProvider)));

// ─── Auth state ───────────────────────────────────────────────────────────────

/// Holds the current auth token (null = logged out).
final authTokenProvider = StateProvider<AuthToken?>((ref) => null);

/// Auth controller — handles login, logout, and session restoration.
class AuthNotifier extends StateNotifier<AsyncValue<AuthToken?>> {
  AuthNotifier({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required AuthRepository repository,
    required StateController<AuthToken?> tokenController,
  })  : _login = loginUseCase,
        _logout = logoutUseCase,
        _repository = repository,
        _tokenController = tokenController,
        super(const AsyncValue.loading()) {
    _restoreSession();
  }

  final LoginUseCase _login;
  final LogoutUseCase _logout;
  final AuthRepository _repository;
  final StateController<AuthToken?> _tokenController;

  Future<void> _restoreSession() async {
    final saved = await _repository.getSavedSession();
    _tokenController.state = saved;
    state = AsyncValue.data(saved);
  }

  Future<String?> login(String username, String password) async {
    state = const AsyncValue.loading();
    final result = await _login(username: username, password: password);
    return result.when(
      onSuccess: (token) {
        _tokenController.state = token;
        state = AsyncValue.data(token);
        return null; // no error
      },
      onFailure: (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return failure.message;
      },
    );
  }

  Future<void> logout() async {
    await _logout();
    _tokenController.state = null;
    state = const AsyncValue.data(null);
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<AuthToken?>>((ref) {
  return AuthNotifier(
    loginUseCase: ref.watch(loginUseCaseProvider),
    logoutUseCase: ref.watch(logoutUseCaseProvider),
    repository: ref.watch(authRepositoryProvider),
    tokenController: ref.read(authTokenProvider.notifier),
  );
});
