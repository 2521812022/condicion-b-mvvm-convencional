/// Modelo de sesión de usuario usado directamente entre servicios, ViewModel y Vista.
class UserSession {
  final String userId;
  final String username;
  final String token;

  const UserSession({
    required this.userId,
    required this.username,
    required this.token,
  });

  factory UserSession.fromMap(Map<String, dynamic> map) {
    return UserSession(
      userId: map['user_id'] as String,
      username: map['username'] as String,
      token: map['token'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'username': username,
      'token': token,
    };
  }
}
