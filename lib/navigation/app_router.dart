// app_router.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_health_consultation/main.dart';
import '../features/appointment/models/appointment.dart';
import '../features/appointment/screens/prescriptions_list.dart';
import '../features/appointment/screens/profile_screen.dart';
import '../features/appointment/screens/appointments_list.dart';
import '../features/appointment/screens/book_appointment.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/providers/auth_provider.dart'; // Add this import

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const AuthWrapper());
        
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
        
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
        
      case '/home':
        return MaterialPageRoute(builder: (_) => const MainNavigation());
        
      case '/appointments':
        return MaterialPageRoute(builder: (_) => const AppointmentsList());
        
      case '/book-appointment':
        final appointment = settings.arguments as Appointment?;
        return MaterialPageRoute(
          builder: (_) => BookAppointment(appointmentToEdit: appointment),
        );
        
      case '/profile':
        return MaterialPageRoute(
          builder: (_) => ProfileScreen(
            onLogout: (context) {
              // Handle logout from profile screen
              Provider.of<AuthProvider>(context, listen: false).logout().then((_) {
                Navigator.pushReplacementNamed(context, '/login');
              });
            },
          ),
        );
        
      case '/prescriptions':
        return MaterialPageRoute(builder: (_) => const PrescriptionsList());
        
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}