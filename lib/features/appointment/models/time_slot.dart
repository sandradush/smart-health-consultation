class TimeSlot {
  final String id;
  final String label; // e.g., "Morning", "Afternoon", "Evening"
  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;

  TimeSlot({
    required this.id,
    required this.label,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });

  String get formattedTime => '${_formatTime(startTime)} - ${_formatTime(endTime)}';

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'isAvailable': isAvailable,
  };

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
    id: json['id'] ?? '',
    label: json['label'] ?? '',
    startTime: DateTime.parse(json['startTime']),
    endTime: DateTime.parse(json['endTime']),
    isAvailable: json['isAvailable'] ?? false,
  );
}