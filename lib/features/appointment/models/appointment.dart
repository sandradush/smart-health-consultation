import 'package:smart_health_consultation/features/appointment/models/appointment_status.dart';
import 'package:smart_health_consultation/features/appointment/models/consultation_type.dart';
import 'package:smart_health_consultation/features/appointment/models/time_slot.dart';

class Appointment {
  String id;
  String patientId;
  String patientName;
  String patientPhone;
  String patientEmail;
  String? doctorId;
  String? doctorName;
  String? doctorSpecialization;
  DateTime appointmentDate;
  TimeSlot timeSlot;
  AppointmentStatus status;
  ConsultationType consultationType;
  String? notes;
  String? symptoms;
  String? transferToDoctorId;
  String? transferToDoctorName;
  DateTime createdAt;
  DateTime? updatedAt;
  String? cancelReason;
  String? doctorNotes;
  String? meetingLink;
  String? chatRoomId;

  Appointment({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.patientPhone,
    required this.patientEmail,
    this.doctorId,
    this.doctorName,
    this.doctorSpecialization,
    required this.appointmentDate,
    required this.timeSlot,
    this.status = AppointmentStatus.pending,
    this.consultationType = ConsultationType.inPerson,
    this.notes,
    this.symptoms,
    this.transferToDoctorId,
    this.transferToDoctorName,
    required this.createdAt,
    this.updatedAt,
    this.cancelReason,
    this.doctorNotes,
    this.meetingLink,
    this.chatRoomId,
  });

  // CopyWith method - make all parameters optional
  Appointment copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? patientPhone,
    String? patientEmail,
    String? doctorId,
    String? doctorName,
    String? doctorSpecialization,
    DateTime? appointmentDate,
    TimeSlot? timeSlot,
    AppointmentStatus? status,
    ConsultationType? consultationType,
    String? notes,
    String? symptoms,
    String? transferToDoctorId,
    String? transferToDoctorName,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? cancelReason,
    String? doctorNotes,
    String? meetingLink,
    String? chatRoomId,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      patientPhone: patientPhone ?? this.patientPhone,
      patientEmail: patientEmail ?? this.patientEmail,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialization: doctorSpecialization ?? this.doctorSpecialization,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
      consultationType: consultationType ?? this.consultationType,
      notes: notes ?? this.notes,
      symptoms: symptoms ?? this.symptoms,
      transferToDoctorId: transferToDoctorId ?? this.transferToDoctorId,
      transferToDoctorName: transferToDoctorName ?? this.transferToDoctorName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      cancelReason: cancelReason ?? this.cancelReason,
      doctorNotes: doctorNotes ?? this.doctorNotes,
      meetingLink: meetingLink ?? this.meetingLink,
      chatRoomId: chatRoomId ?? this.chatRoomId,
    );
  }

  bool get isEditable => status == AppointmentStatus.pending;
  bool get isPending => status == AppointmentStatus.pending;
  bool get canBeCancelled => status != AppointmentStatus.completed && 
                             status != AppointmentStatus.cancelled;
  bool get canBeTransferred => status == AppointmentStatus.pending || 
                               status == AppointmentStatus.approved;

  Map<String, dynamic> toJson() => {
    'id': id,
    'patientId': patientId,
    'patientName': patientName,
    'patientPhone': patientPhone,
    'patientEmail': patientEmail,
    'doctorId': doctorId,
    'doctorName': doctorName,
    'doctorSpecialization': doctorSpecialization,
    'appointmentDate': appointmentDate.toIso8601String(),
    'timeSlot': timeSlot.toJson(),
    'status': status.name,
    'consultationType': consultationType.name,
    'notes': notes,
    'symptoms': symptoms,
    'transferToDoctorId': transferToDoctorId,
    'transferToDoctorName': transferToDoctorName,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'cancelReason': cancelReason,
    'doctorNotes': doctorNotes,
    'meetingLink': meetingLink,
    'chatRoomId': chatRoomId,
  };

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    id: json['id'] ?? '',
    patientId: json['patientId'] ?? '',
    patientName: json['patientName'] ?? '',
    patientPhone: json['patientPhone'] ?? '',
    patientEmail: json['patientEmail'] ?? '',
    doctorId: json['doctorId'],
    doctorName: json['doctorName'],
    doctorSpecialization: json['doctorSpecialization'],
    appointmentDate: DateTime.parse(json['appointmentDate']),
    timeSlot: TimeSlot.fromJson(json['timeSlot']),
    status: AppointmentStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => AppointmentStatus.pending,
    ),
    consultationType: ConsultationType.values.firstWhere(
      (e) => e.name == json['consultationType'],
      orElse: () => ConsultationType.inPerson,
    ),
    notes: json['notes'],
    symptoms: json['symptoms'],
    transferToDoctorId: json['transferToDoctorId'],
    transferToDoctorName: json['transferToDoctorName'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    cancelReason: json['cancelReason'],
    doctorNotes: json['doctorNotes'],
    meetingLink: json['meetingLink'],
    chatRoomId: json['chatRoomId'],
  );
}