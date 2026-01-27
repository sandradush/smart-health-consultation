import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  String? _userToken;
  String? _userEmail;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get userToken => _userToken;
  String? get userEmail => _userEmail;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock login logic
    if (email.isNotEmpty && password.isNotEmpty) {
      _userToken = 'mock_jwt_token';
      _userEmail = email;
      
      // Store in memory (temporary for testing)
      // In production, use secure storage
      
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _error = 'Invalid email or password';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _userToken = null;
    _userEmail = null;
    notifyListeners();
  }

  bool get isAuthenticated => _userToken != null;
}