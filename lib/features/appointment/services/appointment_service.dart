import 'package:smart_health_consultation/features/auth/services/user_service.dart';
import '../models/appointment.dart';
import '../models/appointment_status.dart';
import '../models/consultation_type.dart';
import '../models/time_slot.dart';


class AppointmentService {
  Future<List<Appointment>> getUserAppointments() async {
    // Get current user
    final userId = UserService().currentUserId;
    if (userId == null) return [];
    
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Return dummy data filtered by current user - replace with actual API call
    return [
      Appointment(
        id: '1',
        patientId: userId, // Use current user ID
        patientName: UserService().currentUser?.name ?? 'User',
        patientPhone: UserService().currentUser?.phone ?? '1234567890',
        patientEmail: UserService().currentUser?.email ?? 'user@email.com',
        doctorId: '1',
        doctorName: 'Dr. John Smith',
        doctorSpecialization: 'Cardiologist',
        appointmentDate: DateTime.now().add(const Duration(days: 1)),
        timeSlot: TimeSlot(
          id: '1',
          label: 'Morning',
          startTime: DateTime(2024, 1, 1, 9, 0),
          endTime: DateTime(2024, 1, 1, 10, 0),
          isAvailable: true,
        ),
        status: AppointmentStatus.pending,
        consultationType: ConsultationType.videoCall,
        createdAt: DateTime.now(),
      ),
      Appointment(
        id: '2',
        patientId: userId, // Use current user ID
        patientName: UserService().currentUser?.name ?? 'User',
        patientPhone: UserService().currentUser?.phone ?? '1234567890',
        patientEmail: UserService().currentUser?.email ?? 'user@email.com',
        doctorId: '2',
        doctorName: 'Dr. Sarah Johnson',
        doctorSpecialization: 'Dermatologist',
        appointmentDate: DateTime.now().add(const Duration(days: 3)),
        timeSlot: TimeSlot(
          id: '2',
          label: 'Afternoon',
          startTime: DateTime(2024, 1, 1, 14, 0),
          endTime: DateTime(2024, 1, 1, 15, 0),
          isAvailable: true,
        ),
        status: AppointmentStatus.confirmed,
        consultationType: ConsultationType.chat,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  Future<Appointment> bookAppointment(Appointment appointment) async {
    // Get current user
    final user = UserService().currentUser;
    if (user == null) throw Exception('User not logged in');
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    // Add current user info to appointment
    final updatedAppointment = appointment.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientId: user.id,
      patientName: user.name,
      patientEmail: user.email,
      patientPhone: user.phone ?? '',
    );
    
    return updatedAppointment;
  }

  Future<Appointment> updateAppointment(Appointment appointment) async {
    // Get current user
    final userId = UserService().currentUserId;
    if (userId == null || appointment.patientId != userId) {
      throw Exception('Unauthorized to update this appointment');
    }
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Return updated appointment
    return appointment.copyWith(updatedAt: DateTime.now());
  }

  Future<void> cancelAppointment(String appointmentId, String reason) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> transferAppointment(
    String appointmentId,
    String newDoctorId,
    String newDoctorName,
  ) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> approveAppointment(String appointmentId) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
  }
}