import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_health_consultation/features/auth/models/auth_response.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;

  final AuthService _authService = AuthService();

  AuthProvider() {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    if (token != null) {
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<AuthResponse> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.login(email, password);
      
      if (response.success && response.user != null) {
        _user = response.user;
        _isAuthenticated = true;
        
        final prefs = await SharedPreferences.getInstance();
        if (response.token != null) {
          prefs.setString('token', response.token!);
        }
        if (response.user != null) {
          prefs.setString('userData', json.encode(response.user!.toJson()));
        }
      }
      
      return response;
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'An error occurred: $e',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<AuthResponse> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.register(
        name,
        email,
        phone,
        password,
      );
      
      if (response.success && response.user != null) {
        _user = response.user;
        _isAuthenticated = true;
        
        final prefs = await SharedPreferences.getInstance();
        if (response.token != null) {
          prefs.setString('token', response.token!);
        }
        if (response.user != null) {
          prefs.setString('userData', json.encode(response.user!.toJson()));
        }
      }
      
      return response;
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'An error occurred: $e',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      _user = null;
      _isAuthenticated = false;
    } catch (e) {
      print('Logout error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}