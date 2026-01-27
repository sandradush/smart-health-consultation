enum AppointmentStatus {
  pending('Pending', 'Pending'),
  confirmed('Confirmed', 'Confirmed'),
  completed('Completed', 'Completed'),
  cancelled('Cancelled', 'Cancelled'),
  rescheduled('Rescheduled', 'Rescheduled');

  final String displayName;
  final String value;

  const AppointmentStatus(this.displayName, this.value);
}