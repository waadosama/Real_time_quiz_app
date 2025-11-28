class UserModel {
  final String username;
  final String email;
  final String? token;
  final DateTime? loginTime;

  UserModel({
    required this.username,
    required this.email,
    this.token,
    this.loginTime,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'token': token,
      'loginTime': loginTime?.toIso8601String(),
    };
  }

  // Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      token: json['token'],
      loginTime:
          json['loginTime'] != null ? DateTime.parse(json['loginTime']) : null,
    );
  }

  // Create empty user
  factory UserModel.empty() {
    return UserModel(
      username: '',
      email: '',
    );
  }
}
