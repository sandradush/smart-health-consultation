import 'package:smart_health_consultation/features/appointment/models/time_slot.dart';

class Doctor {
  final String id;
  final String name;
  final String specialization;
  final double rating;
  final int experienceYears;
  final String imageUrl;
  final String hospital;
  final double consultationFee;
  final List<String> availableDays;
  final List<TimeSlot> availableSlots;
  final bool availableForVideo;
  final bool availableForVoice;
  final bool availableForChat;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.rating,
    required this.experienceYears,
    required this.imageUrl,
    required this.hospital,
    required this.consultationFee,
    required this.availableDays,
    required this.availableSlots,
    this.availableForVideo = true,
    this.availableForVoice = true,
    this.availableForChat = true,
  });

  String get experience => '$experienceYears+ years';

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'specialization': specialization,
    'rating': rating,
    'experienceYears': experienceYears,
    'imageUrl': imageUrl,
    'hospital': hospital,
    'consultationFee': consultationFee,
    'availableDays': availableDays,
    'availableSlots': availableSlots.map((slot) => slot.toJson()).toList(),
    'availableForVideo': availableForVideo,
    'availableForVoice': availableForVoice,
    'availableForChat': availableForChat,
  };

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    specialization: json['specialization'] ?? '',
    rating: json['rating']?.toDouble() ?? 0.0,
    experienceYears: json['experienceYears'] ?? 0,
    imageUrl: json['imageUrl'] ?? '',
    hospital: json['hospital'] ?? '',
    consultationFee: json['consultationFee']?.toDouble() ?? 0.0,
    availableDays: List<String>.from(json['availableDays'] ?? []),
    availableSlots: (json['availableSlots'] as List<dynamic>?)
        ?.map((slot) => TimeSlot.fromJson(slot))
        .toList() ?? [],
    availableForVideo: json['availableForVideo'] ?? true,
    availableForVoice: json['availableForVoice'] ?? true,
    availableForChat: json['availableForChat'] ?? true,
  );
}