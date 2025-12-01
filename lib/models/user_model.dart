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

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'token': token,
      'loginTime': loginTime?.toIso8601String(),
    };
  }


  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      token: json['token'],
      loginTime:
          json['loginTime'] != null ? DateTime.parse(json['loginTime']) : null,
    );
  }
  factory UserModel.empty() {
    return UserModel(
      username: '',
      email: '',
    );
  }
}
