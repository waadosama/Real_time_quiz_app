class RegisterModel {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final int? age;

  RegisterModel({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.age,
  });

  String? validate() {
    if (username.isEmpty) {
      return 'Username is required';
    }
    if (username.length < 3) {
      return 'Username must be at least 3 characters';
    }
    if (email.isEmpty) {
      return 'Email is required';
    }
    if (!_isValidEmail(email)) {
      return 'Please enter a valid email';
    }
    if (password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!_hasNumber(password)) {
      return 'Password must contain at least one number';
    }
    if (confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    if (age != null && age! < 13) {
      return 'You must be at least 13 years old';
    }
    return null; 
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool _hasNumber(String password) {
    return password.contains(RegExp(r'[0-9]'));
  }
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'age': age,
    };
  }

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      confirmPassword: json['confirmPassword'] ?? '',
      age: json['age'],
    );
  }
}
