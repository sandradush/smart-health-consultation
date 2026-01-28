import 'package:flutter/material.dart';

enum AppointmentStatus {
  pending('Pending', Icons.access_time, Colors.orange),
  confirmed('Confirmed', Icons.check_circle, Colors.green),
  completed('Completed', Icons.done_all, Colors.blue),
  cancelled('Cancelled', Icons.cancel, Colors.red),
  transferred('Transferred', Icons.swap_horiz, Colors.purple),
  approved('Approved', Icons.verified, Colors.green),
  rejected('Rejected', Icons.close, Colors.red);

  final String displayName;
  final IconData icon;
  final Color color;

  const AppointmentStatus(this.displayName, this.icon, this.color);
}