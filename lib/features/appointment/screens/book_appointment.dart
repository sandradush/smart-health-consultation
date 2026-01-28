import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_health_consultation/features/auth/services/user_service.dart';
import '../models/appointment.dart';
import '../models/appointment_status.dart';
import '../models/consultation_type.dart';
import '../models/doctor.dart';
import '../models/time_slot.dart';
import '../providers/appointment_provider.dart';


class BookAppointment extends StatefulWidget {
  final Appointment? appointmentToEdit;

  const BookAppointment({
    Key? key,
    this.appointmentToEdit,
  }) : super(key: key);

  @override
  _BookAppointmentState createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _symptomsController = TextEditingController();
  final _notesController = TextEditingController();
  
  Doctor? _selectedDoctor;
  DateTime? _selectedDate;
  TimeSlot? _selectedTimeSlot;
  late ConsultationType _selectedConsultationType;
  String _urgency = 'Normal';

  final List<Doctor> _doctors = [
    Doctor(
      id: '1',
      name: 'Dr. John Smith',
      specialization: 'Cardiologist',
      rating: 4.8,
      experienceYears: 10,
      imageUrl: '',
      hospital: 'City Hospital',
      consultationFee: 100.0,
      availableDays: ['Mon', 'Wed', 'Fri'],
      availableSlots: [],
    ),
    Doctor(
      id: '2',
      name: 'Dr. Sarah Johnson',
      specialization: 'Dermatologist',
      rating: 4.9,
      experienceYears: 8,
      imageUrl: '',
      hospital: 'Skin Care Clinic',
      consultationFee: 120.0,
      availableDays: ['Tue', 'Thu', 'Sat'],
      availableSlots: [],
    ),
    Doctor(
      id: '3',
      name: 'Dr. Michael Brown',
      specialization: 'Pediatrician',
      rating: 4.7,
      experienceYears: 15,
      imageUrl: '',
      hospital: 'Children\'s Hospital',
      consultationFee: 90.0,
      availableDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
      availableSlots: [],
    ),
  ];

  final List<TimeSlot> _timeSlots = [
    TimeSlot(
      id: '1',
      label: 'Morning (9:00 AM - 12:00 PM)',
      startTime: DateTime(2024, 1, 1, 9, 0),
      endTime: DateTime(2024, 1, 1, 12, 0),
      isAvailable: true,
    ),
    TimeSlot(
      id: '2',
      label: 'Afternoon (1:00 PM - 4:00 PM)',
      startTime: DateTime(2024, 1, 1, 13, 0),
      endTime: DateTime(2024, 1, 1, 16, 0),
      isAvailable: true,
    ),
    TimeSlot(
      id: '3',
      label: 'Evening (5:00 PM - 8:00 PM)',
      startTime: DateTime(2024, 1, 1, 17, 0),
      endTime: DateTime(2024, 1, 1, 20, 0),
      isAvailable: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    // Get current user
    final user = UserService().currentUser;
    
    if (widget.appointmentToEdit != null) {
      // Editing existing appointment
      _selectedDoctor = _getDoctorFromAppointment(widget.appointmentToEdit!);
      _selectedDate = widget.appointmentToEdit!.appointmentDate;
      _selectedTimeSlot = widget.appointmentToEdit!.timeSlot;
      _selectedConsultationType = widget.appointmentToEdit!.consultationType;
      _symptomsController.text = widget.appointmentToEdit!.symptoms ?? '';
      _notesController.text = widget.appointmentToEdit!.notes ?? '';
    } else {
      // Creating new appointment - set current user info
      _selectedConsultationType = ConsultationType.videoCall;
      _nameController.text = user?.name ?? '';
      _emailController.text = user?.email ?? '';
      _phoneController.text = user?.phone ?? '';
    }
  }

  Doctor? _getDoctorFromAppointment(Appointment appointment) {
    if (appointment.doctorId == null || appointment.doctorName == null) {
      return null;
    }
    
    return Doctor(
      id: appointment.doctorId!,
      name: appointment.doctorName!,
      specialization: appointment.doctorSpecialization ?? '',
      rating: 0.0,
      experienceYears: 0,
      imageUrl: '',
      hospital: '',
      consultationFee: 0.0,
      availableDays: [],
      availableSlots: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.appointmentToEdit != null 
            ? 'Edit Appointment' 
            : 'Book Appointment'
        ),
        actions: widget.appointmentToEdit != null ? [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmation(context);
            },
            tooltip: 'Delete Appointment',
          ),
        ] : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Consultation Type Selection
              _buildConsultationTypeSection(),
              
              const SizedBox(height: 24),
              
              // Your Information
              _buildUserInfoSection(),
              
              const SizedBox(height: 24),
              
              // Doctor Selection
              _buildDoctorSelection(),
              
              const SizedBox(height: 24),
              
              // Date Selection
              _buildDateSelection(),
              
              const SizedBox(height: 24),
              
              // Time Slot Selection
              _buildTimeSlotSelection(),
              
              const SizedBox(height: 24),
              
              // Symptoms
              _buildSymptomsSection(),
              
              const SizedBox(height: 24),
              
              // Notes
              _buildNotesSection(),
              
              const SizedBox(height: 24),
              
              // Urgency
              _buildUrgencySection(),
              
              const SizedBox(height: 32),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitBooking,
                  child: Text(
                    widget.appointmentToEdit != null 
                      ? 'Update Appointment' 
                      : 'Book Appointment',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsultationTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Consultation Type',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildConsultationTypeCard(
                ConsultationType.videoCall,
                Icons.videocam,
                'Video Call',
                Colors.blue,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildConsultationTypeCard(
                ConsultationType.chat,
                Icons.chat,
                'Chat',
                Colors.green,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildConsultationTypeCard(
                ConsultationType.voiceCall,
                Icons.phone,
                'Voice Call',
                Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConsultationTypeCard(
    ConsultationType type,
    IconData icon,
    String label,
    Color color,
  ) {
    final isSelected = _selectedConsultationType == type;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedConsultationType = type;
        });
      },
      child: Card(
        color: isSelected ? color.withOpacity(0.1) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? color : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              readOnly: widget.appointmentToEdit == null, // Read-only for new bookings
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              readOnly: widget.appointmentToEdit == null, // Read-only for new bookings
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              readOnly: widget.appointmentToEdit == null, // Read-only for new bookings
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Doctor',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (_selectedDoctor != null) ...[
              _buildDoctorCard(_selectedDoctor!),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedDoctor = null;
                  });
                },
                child: const Text('Change Doctor'),
              ),
            ] else ...[
              ..._doctors.map((doctor) {
                return Column(
                  children: [
                    _buildDoctorCard(doctor),
                    const SizedBox(height: 8),
                  ],
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    final isSelected = _selectedDoctor?.id == doctor.id;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDoctor = doctor;
        });
      },
      child: Card(
        color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor.specialization,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(doctor.rating.toString()),
                        const SizedBox(width: 12),
                        Icon(Icons.work, color: Colors.blue, size: 16),
                        const SizedBox(width: 4),
                        Text('${doctor.experienceYears} yrs'),
                      ],
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Date',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (_selectedDate != null) ...[
              Text(
                'Selected: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
            ],
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(7, (index) {
                  final date = DateTime.now().add(Duration(days: index));
                  final isSelected = _selectedDate?.day == date.day && 
                    _selectedDate?.month == date.month;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getDayName(date.weekday),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${date.day}',
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _getMonthName(date.month),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Time Slot',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _timeSlots.map((slot) {
                final isSelected = _selectedTimeSlot?.id == slot.id;
                return ChoiceChip(
                  label: Text(slot.label),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedTimeSlot = selected ? slot : null;
                    });
                  },
                  selectedColor: Colors.blue,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Symptoms (Optional)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _symptomsController,
              decoration: const InputDecoration(
                hintText: 'Describe your symptoms...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Additional Notes (Optional)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                hintText: 'Any additional information...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUrgencySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Urgency Level',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _urgency,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              items: ['Normal', 'Urgent', 'Emergency'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _urgency = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1: return 'Jan';
      case 2: return 'Feb';
      case 3: return 'Mar';
      case 4: return 'Apr';
      case 5: return 'May';
      case 6: return 'Jun';
      case 7: return 'Jul';
      case 8: return 'Aug';
      case 9: return 'Sep';
      case 10: return 'Oct';
      case 11: return 'Nov';
      case 12: return 'Dec';
      default: return '';
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Appointment'),
        content: const Text('Are you sure you want to delete this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAppointment(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteAppointment(BuildContext context) async {
    try {
      await Provider.of<AppointmentProvider>(context, listen: false)
          .cancelAppointment(widget.appointmentToEdit!.id, 'Deleted by user');
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointment deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting appointment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedDoctor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a doctor')),
      );
      return;
    }
    
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date')),
      );
      return;
    }
    
    if (_selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time slot')),
      );
      return;
    }

    final appointment = Appointment(
      id: widget.appointmentToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      patientId: UserService().currentUserId ?? 'unknown',
      patientName: _nameController.text,
      patientPhone: _phoneController.text,
      patientEmail: _emailController.text,
      doctorId: _selectedDoctor!.id,
      doctorName: _selectedDoctor!.name,
      doctorSpecialization: _selectedDoctor!.specialization,
      appointmentDate: _selectedDate!,
      timeSlot: _selectedTimeSlot!,
      status: widget.appointmentToEdit?.status ?? AppointmentStatus.pending,
      consultationType: _selectedConsultationType,
      symptoms: _symptomsController.text.isNotEmpty ? _symptomsController.text : null,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      createdAt: widget.appointmentToEdit?.createdAt ?? DateTime.now(),
    );

    try {
      if (widget.appointmentToEdit != null) {
        await Provider.of<AppointmentProvider>(context, listen: false)
            .updateAppointment(appointment);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment updated successfully')),
        );
      } else {
        await Provider.of<AppointmentProvider>(context, listen: false)
            .bookAppointment(appointment);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment booked successfully')),
        );
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _symptomsController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}