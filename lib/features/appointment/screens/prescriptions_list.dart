import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_health_consultation/features/appointment/models/appointment.dart';
import 'package:smart_health_consultation/features/appointment/providers/appointment_provider.dart';
import 'package:smart_health_consultation/features/appointment/screens/book_appointment.dart';

class PrescriptionsList extends StatelessWidget {
  const PrescriptionsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescriptions'),
      ),
      body: const Center(
        child: Text(
          'Prescriptions will appear here',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
  // In your AppointmentsList widget, add edit functionality
Widget _buildAppointmentCard(Appointment appointment, BuildContext context) {
  return Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                appointment.doctorName ?? 'No Doctor Assigned',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Chip(
                label: Text(appointment.status.displayName),
                backgroundColor: appointment.status.color.withOpacity(0.2),
                labelStyle: TextStyle(color: appointment.status.color),
              ),
            ],
          ),
          // ... other appointment details
          
          if (appointment.isEditable) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookAppointment(
                            appointmentToEdit: appointment,
                          ),
                        ),
                      );
                    },
                    child: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _showCancelDialog(appointment, context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    ),
  );
}

void _showCancelDialog(Appointment appointment, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Cancel Appointment'),
      content: const Text('Are you sure you want to cancel this appointment?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _cancelAppointment(appointment.id, context);
          },
          child: const Text(
            'Yes, Cancel',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}

void _cancelAppointment(String appointmentId, BuildContext context) async {
  try {
    await Provider.of<AppointmentProvider>(context, listen: false)
        .cancelAppointment(appointmentId, 'Cancelled by user');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Appointment cancelled successfully'),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error cancelling appointment: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
}