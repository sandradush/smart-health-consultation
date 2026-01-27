import 'package:smart_health_consultation/features/appointment/models/time_slot.dart';

class AppointmentBookingRequest {
  final String userId;
  final String doctorId;
  final DateTime appointmentDate;
  final TimeSlot selectedSlot;
  final String? notes;
  final String patientName;
  final String patientPhone;
  final String patientEmail;

  AppointmentBookingRequest({
    required this.userId,
    required this.doctorId,
    required this.appointmentDate,
    required this.selectedSlot,
    this.notes,
    required this.patientName,
    required this.patientPhone,
    required this.patientEmail,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'doctorId': doctorId,
    'appointmentDate': appointmentDate.toIso8601String(),
    'selectedSlot': selectedSlot.toJson(),
    'notes': notes,
    'patientName': patientName,
    'patientPhone': patientPhone,
    'patientEmail': patientEmail,
    'createdAt': DateTime.now().toIso8601String(),
  };
}