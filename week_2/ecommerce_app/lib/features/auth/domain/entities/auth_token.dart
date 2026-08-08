/// Domain entity representing a successful auth token.
/// Pure Dart — no Flutter or Dio imports.
class AuthToken {
  const AuthToken({required this.token, required this.userId});

  final String token;
  final int userId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthToken && runtimeType == other.runtimeType && token == other.token && userId == other.userId;

  @override
  int get hashCode => token.hashCode ^ userId.hashCode;

  @override
  String toString() => 'AuthToken(userId: $userId)';
}
