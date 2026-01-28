// user_service.dart
import 'package:smart_health_consultation/features/auth/models/user.dart';

class UserService {
  static UserService? _instance;
  User? _currentUser;
  
  factory UserService() {
    _instance ??= UserService._internal();
    return _instance!;
  }
  
  UserService._internal();
  
  User? get currentUser => _currentUser;
  String? get currentUserId => _currentUser?.id;
  
  void setUser(User user) {
    _currentUser = user;
  }
  
  void clearUser() {
    _currentUser = null;
  }
  
  bool get isLoggedIn => _currentUser != null;
}