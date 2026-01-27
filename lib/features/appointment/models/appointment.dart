import 'package:smart_health_consultation/features/appointment/models/appointment_status.dart';
import 'package:smart_health_consultation/features/appointment/models/time_slot.dart';

class Appointment {
  final String id;
  final String userId;
  final String doctorId;
  final DateTime appointmentDate;
  final TimeSlot timeSlot;
  final AppointmentStatus status;
  final String? notes;
  final DateTime createdAt;

  Appointment({
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.appointmentDate,
    required this.timeSlot,
    this.status = AppointmentStatus.pending,
    this.notes,
    required this.createdAt,
  });

  // Convert to/from JSON for API/firebase
  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'doctorId': doctorId,
    'appointmentDate': appointmentDate.toIso8601String(),
    'timeSlot': timeSlot.toJson(),
    'status': status.name,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    id: json['id'] ?? '',
    userId: json['userId'] ?? '',
    doctorId: json['doctorId'] ?? '',
    appointmentDate: DateTime.parse(json['appointmentDate']),
    timeSlot: TimeSlot.fromJson(json['timeSlot']),
    status: AppointmentStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => AppointmentStatus.pending,
    ),
    notes: json['notes'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}