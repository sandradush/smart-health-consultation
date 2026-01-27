import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_health_consultation/core/constants/app_colors.dart';
import 'package:smart_health_consultation/features/auth/providers/auth_provider.dart';
import 'package:smart_health_consultation/features/auth/screens/login_screen.dart';
import 'package:smart_health_consultation/features/auth/screens/register_screen.dart';
import 'package:smart_health_consultation/features/dashboard/screens/patient_dashboard.dart';

void main() {
  // Ensure Google Fonts is initialized for web
  GoogleFonts.config.allowRuntimeFetching = true;
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const SmartHealthApp(),
    ),
  );
}

class SmartHealthApp extends StatelessWidget {
  const SmartHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Health Consultation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        fontFamily: GoogleFonts.inter().fontFamily,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Check if user is already logged in
          if (authProvider.isAuthenticated) {
            return const PatientDashboard();
          }
          return const LoginScreen();
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const PatientDashboard(),
      },
    );
  }
}