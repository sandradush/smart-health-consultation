import 'package:smart_health_consultation/features/auth/models/user.dart';

class AuthResponse {
  final bool success;
  final String message;
  final User? user;
  final String? token;

  AuthResponse({
    required this.success,
    required this.message,
    this.user,
    this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    success: json['success'] ?? false,
    message: json['message'] ?? '',
    user: json['user'] != null ? User.fromJson(json['user']) : null,
    token: json['token'],
  );
}