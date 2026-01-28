import '../models/auth_response.dart';
import '../models/user.dart';
import 'user_service.dart';

class AuthService {
  Future<AuthResponse> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    if (email.isNotEmpty && password.isNotEmpty) {
      final user = User(
        id: '1',
        name: email.contains('@') ? email.split('@')[0] : 'User',
        email: email,
        phone: '1234567890',
        role: 'patient',
        createdAt: DateTime.now(),
      );
      
      // Store current user
      UserService().setUser(user);
      
      return AuthResponse(
        success: true,
        message: 'Login successful',
        user: user,
        token: 'mock-jwt-token-123456',
      );
    }

    return AuthResponse(
      success: false,
      message: 'Invalid email or password',
    );
  }

  Future<AuthResponse> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    if (name.isNotEmpty && email.isNotEmpty && phone.isNotEmpty && password.isNotEmpty) {
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        phone: phone,
        role: 'patient',
        createdAt: DateTime.now(),
      );
      
      // Store current user
      UserService().setUser(user);
      
      return AuthResponse(
        success: true,
        message: 'Registration successful',
        user: user,
        token: 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}',
      );
    }

    return AuthResponse(
      success: false,
      message: 'Please fill all fields',
    );
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(seconds: 1));
    // Clear current user
    UserService().clearUser();
  }
}