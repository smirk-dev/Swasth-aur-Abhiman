class User {
  final String id;
  final String email;
  final String fullName;
  final String role;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'role': role,
    };
  }
}

class AuthResponse {
  final String accessToken;
  final User user;

  AuthResponse({
    required this.accessToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'],
      user: User.fromJson(json['user']),
    );
  }
}

class LoginRequest {
  final String email;
  final String password;
  final String role;

  LoginRequest({
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'role': role,
    };
  }
}

class RegisterRequest {
  final String email;
  final String password;
  final String role;
  final String fullName;
  final String gender;
  final String? phoneNumber;
  final String? block;
  final String? address;
  final int? age;
  final String? specialization;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.role,
    required this.fullName,
    required this.gender,
    this.phoneNumber,
    this.block,
    this.address,
    this.age,
    this.specialization,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
      'role': role,
      'fullName': fullName,
      'gender': gender,
    };

    if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
    if (block != null) data['block'] = block;
    if (address != null) data['address'] = address;
    if (age != null) data['age'] = age;
    if (specialization != null) data['specialization'] = specialization;

    return data;
  }
}
