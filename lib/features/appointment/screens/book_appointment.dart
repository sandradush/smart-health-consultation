import 'package:flutter/material.dart';
import 'package:smart_health_consultation/core/constants/app_colors.dart';
import 'package:smart_health_consultation/core/constants/app_styles.dart';
import 'package:smart_health_consultation/core/widgets/custom_button.dart';
import 'package:smart_health_consultation/core/widgets/custom_textfield.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  int _selectedDoctor = 0;
  String _selectedDate = '';
  String _selectedTime = '';
  String _selectedType = 'Clinic';
  String _selectedReason = 'General Checkup';

  final List<Map<String, dynamic>> _doctors = [
    {
      'name': 'Dr. Alice Uwase',
      'specialty': 'General Physician',
      'rating': 4.8,
      'reviews': 124,
      'available': true,
    },
    {
      'name': 'Dr. James Nkusi',
      'specialty': 'Cardiologist',
      'rating': 4.9,
      'reviews': 89,
      'available': true,
    },
    {
      'name': 'Dr. Marie Claire',
      'specialty': 'Pediatrician',
      'rating': 4.7,
      'reviews': 156,
      'available': false,
    },
  ];

  final List<String> _appointmentTypes = ['Clinic', 'Video Call'];
  final List<String> _reasons = [
    'General Checkup',
    'Follow-up',
    'Emergency',
    'Prescription Renewal',
    'Lab Results',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Selection
            Text(
              'Select Doctor',
              style: AppStyles.titleLarge,
            ),
            const SizedBox(height: 16),
            ..._doctors.asMap().entries.map((entry) {
              final index = entry.key;
              final doctor = entry.value;
              return _buildDoctorCard(index, doctor);
            }).toList(),
            const SizedBox(height: 24),

            // Appointment Type
            Text(
              'Appointment Type',
              style: AppStyles.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: _appointmentTypes.map((type) {
                return ChoiceChip(
                  label: Text(type),
                  selected: _selectedType == type,
                  onSelected: (selected) {
                    setState(() => _selectedType = type);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Date Selection
            Text(
              'Select Date',
              style: AppStyles.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _generateDates(),
              ),
            ),
            const SizedBox(height: 24),

            // Time Slots
            Text(
              'Select Time',
              style: AppStyles.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _generateTimeSlots(),
            ),
            const SizedBox(height: 24),

            // Reason
            Text(
              'Reason for Visit',
              style: AppStyles.titleLarge,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedReason,
              items: _reasons.map((reason) {
                return DropdownMenuItem<String>(
                  value: reason,
                  child: Text(reason),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedReason = value!);
              },
              decoration: AppStyles.inputDecoration.copyWith(
                labelText: 'Select reason',
              ),
            ),
            const SizedBox(height: 32),

            // Symptoms
            CustomTextField(
              label: 'Symptoms (Optional)',
              hintText: 'Describe your symptoms',
              maxLines: 3,
            ),
            const SizedBox(height: 40),

            // Book Button
            CustomButton(
              text: 'Book Appointment',
              onPressed: _bookAppointment,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(int index, Map<String, dynamic> doctor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: RadioListTile<int>(
        title: Text(
          doctor['name'],
          style: AppStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(doctor['specialty']),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                Text(' ${doctor['rating']} (${doctor['reviews']} reviews)'),
              ],
            ),
          ],
        ),
        value: index,
        groupValue: _selectedDoctor,
        onChanged: doctor['available']
            ? (value) => setState(() => _selectedDoctor = value!)
            : null,
        secondary: doctor['available']
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Available',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 12,
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Unavailable',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
      ),
    );
  }

  List<Widget> _generateDates() {
    final List<Widget> dates = [];
    final now = DateTime.now();
    
    for (int i = 0; i < 7; i++) {
      final date = now.add(Duration(days: i));
      final isSelected = _selectedDate == date.toIso8601String().split('T')[0];
      
      dates.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date.toIso8601String().split('T')[0];
            });
          },
          child: Container(
            width: 80,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey[300]!,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getDayName(date.weekday),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date.day.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getMonthName(date.month),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return dates;
  }

  List<Widget> _generateTimeSlots() {
    final List<String> slots = [
      '9:00 AM', '10:00 AM', '11:00 AM', '12:00 PM',
      '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM',
    ];
    
    return slots.map((slot) {
      final isSelected = _selectedTime == slot;
      return GestureDetector(
        onTap: () => setState(() => _selectedTime = slot),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey[300]!,
            ),
          ),
          child: Text(
            slot,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      );
    }).toList();
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  void _bookAppointment() {
    if (_selectedDate.isEmpty || _selectedTime.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select date and time'),
        ),
      );
      return;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Appointment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Doctor: ${_doctors[_selectedDoctor]['name']}'),
            Text('Date: $_selectedDate'),
            Text('Time: $_selectedTime'),
            Text('Type: $_selectedType'),
            Text('Reason: $_selectedReason'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Appointment booked successfully!'),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}