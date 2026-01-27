import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html; // For web localStorage

class LocalStorage {
  static SharedPreferences? _prefs;
  static bool _initialized = false;

  static Future<void> init() async {
    try {
      if (kIsWeb) {
        // For web, SharedPreferences works differently
        _prefs = await SharedPreferences.getInstance();
      } else {
        _prefs = await SharedPreferences.getInstance();
      }
      _initialized = true;
    } catch (e) {
      print('Failed to initialize SharedPreferences: $e');
      // For web, we can use a fallback
      // In the saveString method
if (kIsWeb && _prefs == null) {
  try {
    html.window.localStorage[key] = value;
  } catch (e) {
    print('Failed to save to localStorage: $e');
  }
}

// In the getString method
else if (kIsWeb) {
  try {
    return html.window.localStorage[key];
  } catch (e) {
    print('Failed to get from localStorage: $e');
    return null;
  }
}
    }
  }

  // Helper method to ensure initialization
  static Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await init();
    }
  }

  // Save data
  static Future<void> saveString(String key, String value) async {
    await _ensureInitialized();
    if (_prefs != null) {
      await _prefs!.setString(key, value);
    } else {
      // Fallback for web when SharedPreferences fails
      if (kIsWeb) {
        try {
          window.localStorage[key] = value;
        } catch (e) {
          print('Failed to save to localStorage: $e');
        }
      }
    }
  }

  static Future<void> saveInt(String key, int value) async {
    await _ensureInitialized();
    if (_prefs != null) {
      await _prefs!.setInt(key, value);
    }
  }

  static Future<void> saveBool(String key, bool value) async {
    await _ensureInitialized();
    if (_prefs != null) {
      await _prefs!.setBool(key, value);
    }
  }

  static Future<void> saveDouble(String key, double value) async {
    await _ensureInitialized();
    if (_prefs != null) {
      await _prefs!.setDouble(key, value);
    }
  }

  static Future<void> saveStringList(String key, List<String> value) async {
    await _ensureInitialized();
    if (_prefs != null) {
      await _prefs!.setStringList(key, value);
    }
  }

  // Get data
  static Future<String?> getString(String key) async {
    await _ensureInitialized();
    if (_prefs != null) {
      return _prefs!.getString(key);
    } else if (kIsWeb) {
      try {
        return window.localStorage[key];
      } catch (e) {
        print('Failed to get from localStorage: $e');
        return null;
      }
    }
    return null;
  }

  static Future<int?> getInt(String key) async {
    await _ensureInitialized();
    return _prefs?.getInt(key);
  }

  static Future<bool?> getBool(String key) async {
    await _ensureInitialized();
    return _prefs?.getBool(key);
  }

  static Future<double?> getDouble(String key) async {
    await _ensureInitialized();
    return _prefs?.getDouble(key);
  }

  static Future<List<String>?> getStringList(String key) async {
    await _ensureInitialized();
    return _prefs?.getStringList(key);
  }

  // Remove data
  static Future<void> remove(String key) async {
    await _ensureInitialized();
    if (_prefs != null) {
      await _prefs!.remove(key);
    } else if (kIsWeb) {
      try {
        window.localStorage.remove(key);
      } catch (e) {
        print('Failed to remove from localStorage: $e');
      }
    }
  }

  // Clear all data
  static Future<void> clear() async {
    await _ensureInitialized();
    if (_prefs != null) {
      await _prefs!.clear();
    } else if (kIsWeb) {
      try {
        window.localStorage.clear();
      } catch (e) {
        print('Failed to clear localStorage: $e');
      }
    }
  }

  // Check if key exists
  static Future<bool> containsKey(String key) async {
    await _ensureInitialized();
    if (_prefs != null) {
      return _prefs!.containsKey(key);
    } else if (kIsWeb) {
      try {
        return window.localStorage.containsKey(key);
      } catch (e) {
        print('Failed to check localStorage: $e');
        return false;
      }
    }
    return false;
  }
}