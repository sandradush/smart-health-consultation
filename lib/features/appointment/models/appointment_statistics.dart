class AppointmentStatistics {
  final int totalAppointments;
  final int pendingAppointments;
  final int confirmedAppointments;
  final int completedAppointments;
  final int cancelledAppointments;
  final int todayAppointments;
  final int upcomingAppointments;
  final Map<String, int> monthlyData;

  AppointmentStatistics({
    required this.totalAppointments,
    required this.pendingAppointments,
    required this.confirmedAppointments,
    required this.completedAppointments,
    required this.cancelledAppointments,
    required this.todayAppointments,
    required this.upcomingAppointments,
    required this.monthlyData,
  });

  double get completionRate => totalAppointments > 0 
    ? (completedAppointments / totalAppointments) * 100 
    : 0;

  double get pendingRate => totalAppointments > 0 
    ? (pendingAppointments / totalAppointments) * 100 
    : 0;

  factory AppointmentStatistics.fromJson(Map<String, dynamic> json) => AppointmentStatistics(
    totalAppointments: json['totalAppointments'] ?? 0,
    pendingAppointments: json['pendingAppointments'] ?? 0,
    confirmedAppointments: json['confirmedAppointments'] ?? 0,
    completedAppointments: json['completedAppointments'] ?? 0,
    cancelledAppointments: json['cancelledAppointments'] ?? 0,
    todayAppointments: json['todayAppointments'] ?? 0,
    upcomingAppointments: json['upcomingAppointments'] ?? 0,
    monthlyData: Map<String, int>.from(json['monthlyData'] ?? {}),
  );
}