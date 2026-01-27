import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_health_consultation/app.dart';
import 'package:smart_health_consultation/features/auth/providers/auth_provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const SmartHealthApp(),
    ),
  );
}