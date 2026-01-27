import 'package:smart_health_consultation/features/appointment/models/appointment.dart';

class BookingResponse {
  final bool success;
  final String message;
  final Appointment? appointment;
  final String? bookingId;
  final String? paymentId; // if payment is involved

  BookingResponse({
    required this.success,
    required this.message,
    this.appointment,
    this.bookingId,
    this.paymentId,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) => BookingResponse(
    success: json['success'] ?? false,
    message: json['message'] ?? '',
    appointment: json['appointment'] != null 
      ? Appointment.fromJson(json['appointment']) 
      : null,
    bookingId: json['bookingId'],
    paymentId: json['paymentId'],
  );
}