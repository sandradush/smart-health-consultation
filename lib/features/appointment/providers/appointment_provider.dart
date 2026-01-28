import 'package:flutter/foundation.dart';
import '../models/appointment.dart';
import '../models/appointment_statistics.dart';
import '../models/appointment_status.dart';
import '../services/appointment_service.dart';

class AppointmentProvider with ChangeNotifier {
  List<Appointment> _appointments = [];
  AppointmentStatistics _statistics = AppointmentStatistics(
    totalAppointments: 0,
    pendingAppointments: 0,
    confirmedAppointments: 0,
    completedAppointments: 0,
    cancelledAppointments: 0,
    todayAppointments: 0,
    upcomingAppointments: 0,
    monthlyData: {},
  );
  bool _isLoading = false;

  List<Appointment> get appointments => _appointments;
  List<Appointment> get pendingAppointments =>
      _appointments.where((a) => a.isPending).toList();
  List<Appointment> get recentAppointments =>
      _appointments.take(5).toList();
  AppointmentStatistics get statistics => _statistics;
  bool get isLoading => _isLoading;

  final AppointmentService _service = AppointmentService();

  Future<void> loadAppointments() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _appointments = await _service.getUserAppointments();
      _calculateStatistics();
    } catch (e) {
      // Handle error
      print('Error loading appointments: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> bookAppointment(Appointment appointment) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final newAppointment = await _service.bookAppointment(appointment);
      _appointments.add(newAppointment);
      _calculateStatistics();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAppointment(Appointment appointment) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final updatedAppointment = await _service.updateAppointment(appointment);
      final index = _appointments.indexWhere((a) => a.id == appointment.id);
      if (index != -1) {
        _appointments[index] = updatedAppointment;
      }
      _calculateStatistics();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancelAppointment(String appointmentId, String reason) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _service.cancelAppointment(appointmentId, reason);
      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if (index != -1) {
        _appointments[index] = _appointments[index].copyWith(
          status: AppointmentStatus.cancelled,
          cancelReason: reason,
          updatedAt: DateTime.now(),
        );
      }
      _calculateStatistics();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> transferAppointment(
    String appointmentId,
    String newDoctorId,
    String newDoctorName,
  ) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _service.transferAppointment(
        appointmentId,
        newDoctorId,
        newDoctorName,
      );
      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if (index != -1) {
        _appointments[index] = _appointments[index].copyWith(
          status: AppointmentStatus.transferred,
          transferToDoctorId: newDoctorId,
          transferToDoctorName: newDoctorName,
          updatedAt: DateTime.now(),
        );
      }
      _calculateStatistics();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> approveAppointment(String appointmentId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _service.approveAppointment(appointmentId);
      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if (index != -1) {
        _appointments[index] = _appointments[index].copyWith(
          status: AppointmentStatus.approved,
          updatedAt: DateTime.now(),
        );
      }
      _calculateStatistics();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ADD THIS METHOD - It was missing!
  void _calculateStatistics() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    _statistics = AppointmentStatistics(
      totalAppointments: _appointments.length,
      pendingAppointments: _appointments
          .where((a) => a.status == AppointmentStatus.pending)
          .length,
      confirmedAppointments: _appointments
          .where((a) => a.status == AppointmentStatus.confirmed)
          .length,
      completedAppointments: _appointments
          .where((a) => a.status == AppointmentStatus.completed)
          .length,
      cancelledAppointments: _appointments
          .where((a) => a.status == AppointmentStatus.cancelled)
          .length,
      todayAppointments: _appointments
          .where((a) => a.appointmentDate.year == today.year &&
                       a.appointmentDate.month == today.month &&
                       a.appointmentDate.day == today.day)
          .length,
      upcomingAppointments: _appointments
          .where((a) => a.appointmentDate.isAfter(now) && 
              a.status != AppointmentStatus.cancelled)
          .length,
      monthlyData: _calculateMonthlyData(),
    );
  }

  // ADD THIS HELPER METHOD TOO
  Map<String, int> _calculateMonthlyData() {
    final Map<String, int> monthlyData = {};
    final now = DateTime.now();
    
    for (var appointment in _appointments) {
      final monthKey = '${appointment.appointmentDate.year}-${appointment.appointmentDate.month}';
      monthlyData[monthKey] = (monthlyData[monthKey] ?? 0) + 1;
    }
    
    return monthlyData;
  }
}