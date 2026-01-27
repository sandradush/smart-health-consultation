// lib/core/services/web_storage.dart
import 'package:flutter/foundation.dart';

class WebStorage {
  static Future<void> saveString(String key, String value) async {
    if (kIsWeb) {
      // Store in memory for now (temporary solution)
      // In production, you'd use actual localStorage or IndexedDB
      print('Web: Saving $key = $value');
      // You can use shared_preferences on web, it should work
    }
  }

  static Future<String?> getString(String key) async {
    if (kIsWeb) {
      print('Web: Getting $key');
      return null; // Return null for now
    }
    return null;
  }

  static Future<void> remove(String key) async {
    if (kIsWeb) {
      print('Web: Removing $key');
    }
  }
}