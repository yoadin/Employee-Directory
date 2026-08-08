import 'package:ecommerce_app/core/constants/app_constants.dart';
import 'package:ecommerce_app/core/error/exceptions.dart';
import 'package:ecommerce_app/features/auth/domain/entities/auth_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveSession(AuthToken token);
  Future<AuthToken?> getSession();
  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this._prefs);
  final SharedPreferences _prefs;

  @override
  Future<void> saveSession(AuthToken token) async {
    try {
      await Future.wait([
        _prefs.setString(AppConstants.keyAuthToken, token.token),
        _prefs.setInt(AppConstants.keyUserId, token.userId),
      ]);
    } catch (_) {
      throw const CacheException(message: 'Failed to save session');
    }
  }

  @override
  Future<AuthToken?> getSession() async {
    final token = _prefs.getString(AppConstants.keyAuthToken);
    final userId = _prefs.getInt(AppConstants.keyUserId);
    if (token == null || userId == null) return null;
    return AuthToken(token: token, userId: userId);
  }

  @override
  Future<void> clearSession() async {
    try {
      await Future.wait([
        _prefs.remove(AppConstants.keyAuthToken),
        _prefs.remove(AppConstants.keyUserId),
      ]);
    } catch (_) {
      throw const CacheException(message: 'Failed to clear session');
    }
  }
}
