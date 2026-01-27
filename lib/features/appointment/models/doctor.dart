import 'package:smart_health_consultation/features/appointment/models/time_slot.dart';

class Doctor {
  final String id;
  final String name;
  final String specialization;
  final double rating;
  final int experienceYears;
  final String imageUrl;
  final String hospital;
  final List<String> availableDays; // e.g., ['Mon', 'Wed', 'Fri']
  final List<TimeSlot> availableSlots;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.rating,
    required this.experienceYears,
    required this.imageUrl,
    required this.hospital,
    required this.availableDays,
    required this.availableSlots,
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
    'availableDays': availableDays,
    'availableSlots': availableSlots.map((slot) => slot.toJson()).toList(),
  };

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    specialization: json['specialization'] ?? '',
    rating: json['rating']?.toDouble() ?? 0.0,
    experienceYears: json['experienceYears'] ?? 0,
    imageUrl: json['imageUrl'] ?? '',
    hospital: json['hospital'] ?? '',
    availableDays: List<String>.from(json['availableDays'] ?? []),
    availableSlots: (json['availableSlots'] as List<dynamic>?)
        ?.map((slot) => TimeSlot.fromJson(slot))
        .toList() ?? [],
  );
}