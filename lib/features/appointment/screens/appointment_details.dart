import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_health_consultation/core/constants/app_colors.dart';
import 'package:smart_health_consultation/core/widgets/custom_button.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> appointment;
  final bool isDoctorView;

  const AppointmentDetailsScreen({
    super.key,
    required this.appointment,
    this.isDoctorView = false,
  });

  @override
  State<AppointmentDetailsScreen> createState() => _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  String _selectedTab = 'details'; // 'details', 'prescription', 'history'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isDoctorView ? 'Appointment Details' : 'My Appointment',
        ),
        actions: [
          if (!widget.isDoctorView)
            IconButton(
              onPressed: _cancelAppointment,
              icon: const Icon(Icons.cancel_outlined),
              tooltip: 'Cancel Appointment',
            ),
          IconButton(
            onPressed: _shareAppointment,
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share',
          ),
          IconButton(
            onPressed: _printDetails,
            icon: const Icon(Icons.print_outlined),
            tooltip: 'Print',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card
            _buildHeaderCard(),
            
            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _buildTabButton('Details', 'details'),
                  const SizedBox(width: 8),
                  _buildTabButton('Prescription', 'prescription'),
                  const SizedBox(width: 8),
                  _buildTabButton('History', 'history'),
                ],
              ),
            ),
            
            // Content based on selected tab
            Padding(
              padding: const EdgeInsets.all(16),
              child: _selectedTab == 'details'
                  ? _buildDetailsTab()
                  : _selectedTab == 'prescription'
                      ? _buildPrescriptionTab()
                      : _buildHistoryTab(),
            ),
            
            // Action Buttons
            if (!widget.isDoctorView) _buildPatientActions(),
            if (widget.isDoctorView) _buildDoctorActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Doctor/Patient Avatar
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Icon(
              widget.isDoctorView ? Icons.person : Icons.medical_services,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 20),
          
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isDoctorView
                      ? widget.appointment['patientName'] ?? 'Patient'
                      : widget.appointment['doctorName'] ?? 'Dr. Unknown',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.isDoctorView
                      ? 'Patient'
                      : widget.appointment['doctorSpecialty'] ?? 'General Physician',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(widget.appointment['status'] ?? 'Pending')
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.appointment['status'] ?? 'Pending',
                    style: TextStyle(
                      color: _getStatusColor(widget.appointment['status'] ?? 'Pending'),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Time & Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.appointment['time'] ?? '10:00 AM',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('EEE, MMM dd, yyyy').format(
                  widget.appointment['date'] ?? DateTime.now(),
                ),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, String value) {
    final isSelected = _selectedTab == value;
    return Expanded(
      child: ElevatedButton(
        onPressed: () => setState(() => _selectedTab = value),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.primary : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isSelected ? AppColors.primary : Colors.grey[300]!,
            ),
          ),
          elevation: 0,
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildDetailsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Appointment Information
        _buildSectionTitle('Appointment Information'),
        _buildDetailCard(
          children: [
            _buildDetailRow(
              icon: Icons.calendar_today,
              label: 'Date',
              value: DateFormat('MMMM dd, yyyy').format(
                widget.appointment['date'] ?? DateTime.now(),
              ),
            ),
            _buildDetailRow(
              icon: Icons.access_time,
              label: 'Time',
              value: widget.appointment['time'] ?? '10:00 AM',
            ),
            _buildDetailRow(
              icon: Icons.video_call,
              label: 'Type',
              value: widget.appointment['type'] ?? 'Clinic Visit',
            ),
            _buildDetailRow(
              icon: Icons.timer,
              label: 'Duration',
              value: widget.appointment['duration'] ?? '30 minutes',
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Patient/Doctor Information
        _buildSectionTitle(
          widget.isDoctorView ? 'Patient Information' : 'Doctor Information',
        ),
        _buildDetailCard(
          children: [
            _buildDetailRow(
              icon: Icons.person,
              label: 'Name',
              value: widget.isDoctorView
                  ? widget.appointment['patientName'] ?? 'Patient'
                  : widget.appointment['doctorName'] ?? 'Dr. Unknown',
            ),
            if (!widget.isDoctorView)
              _buildDetailRow(
                icon: Icons.medical_services,
                label: 'Specialization',
                value: widget.appointment['doctorSpecialty'] ?? 'General Physician',
              ),
            if (widget.isDoctorView)
              _buildDetailRow(
                icon: Icons.cake,
                label: 'Age',
                value: '${widget.appointment['patientAge'] ?? 'N/A'} years',
              ),
            if (widget.isDoctorView)
              _buildDetailRow(
                icon: Icons.transgender,
                label: 'Gender',
                value: widget.appointment['patientGender'] ?? 'N/A',
              ),
            _buildDetailRow(
              icon: Icons.phone,
              label: 'Contact',
              value: widget.isDoctorView
                  ? widget.appointment['patientPhone'] ?? 'N/A'
                  : widget.appointment['doctorPhone'] ?? 'N/A',
            ),
            _buildDetailRow(
              icon: Icons.email,
              label: 'Email',
              value: widget.isDoctorView
                  ? widget.appointment['patientEmail'] ?? 'N/A'
                  : widget.appointment['doctorEmail'] ?? 'N/A',
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Reason & Symptoms
        _buildSectionTitle('Reason for Visit'),
        _buildDetailCard(
          children: [
            _buildDetailRow(
              icon: Icons.medical_information,
              label: 'Reason',
              value: widget.appointment['reason'] ?? 'General Checkup',
            ),
            if (widget.appointment['symptoms'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    'Symptoms:',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.appointment['symptoms'],
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            if (widget.appointment['notes'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    'Additional Notes:',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.appointment['notes'],
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
          ],
        ),
        
        // Location (for clinic visits)
        if (widget.appointment['type'] == 'Clinic' && widget.appointment['location'] != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildSectionTitle('Location'),
              _buildDetailCard(
                children: [
                  _buildDetailRow(
                    icon: Icons.location_on,
                    label: 'Clinic Address',
                    value: widget.appointment['location'],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(
                            Icons.map_outlined,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildPrescriptionTab() {
    final prescriptions = widget.appointment['prescriptions'] ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (prescriptions.isEmpty)
          const Center(
            child: Column(
              children: [
                Icon(
                  Icons.medical_services_outlined,
                  size: 80,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No prescription issued yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        else
          ...prescriptions.map<Widget>((prescription) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          prescription['medication'] ?? 'Medication',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.prescription.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            prescription['status'] ?? 'Active',
                            style: TextStyle(
                              color: AppColors.prescription,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildPrescriptionDetailRow('Dosage', prescription['dosage']),
                    _buildPrescriptionDetailRow('Frequency', prescription['frequency']),
                    _buildPrescriptionDetailRow('Duration', prescription['duration']),
                    _buildPrescriptionDetailRow('Instructions', prescription['instructions']),
                    if (prescription['notes'] != null)
                      _buildPrescriptionDetailRow('Notes', prescription['notes']),
                    
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.download),
                            label: const Text('Download'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.share),
                            label: const Text('Share'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.refresh),
                            label: const Text('Refill'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        
        if (widget.isDoctorView)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: CustomButton(
              text: 'Add New Prescription',
              onPressed: _addPrescription,
            ),
          ),
      ],
    );
  }

  Widget _buildHistoryTab() {
    final history = widget.appointment['history'] ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (history.isEmpty)
          const Center(
            child: Column(
              children: [
                Icon(
                  Icons.history_outlined,
                  size: 80,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No history available',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        else
          ...history.map<Widget>((item) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getHistoryIconColor(item['type']).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getHistoryIcon(item['type']),
                            color: _getHistoryIconColor(item['type']),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item['title'] ?? 'Event',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          item['time'] ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (item['description'] != null)
                      Text(
                        item['description'],
                        style: const TextStyle(fontSize: 14),
                      ),
                    if (item['by'] != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'By: ${item['by']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        
        // Add notes section (for doctors)
        if (widget.isDoctorView)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildSectionTitle('Add Clinical Notes'),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter clinical notes here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Save Notes',
                onPressed: () {},
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildPatientActions() {
    final status = widget.appointment['status'] ?? 'Pending';
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (status == 'Upcoming' || status == 'Confirmed')
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Join Video Call',
                    onPressed: _joinVideoCall,
                    backgroundColor: AppColors.consultation,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Reschedule',
                    onPressed: _rescheduleAppointment,
                    backgroundColor: Colors.white,
                    textColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          
          if (status == 'Pending' || status == 'Upcoming')
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: CustomButton(
                text: 'Cancel Appointment',
                onPressed: _cancelAppointment,
                backgroundColor: Colors.white,
                textColor: Colors.red,
              ),
            ),
          
          if (status == 'Completed')
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Download Receipt',
                      onPressed: _downloadReceipt,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'Book Follow-up',
                      onPressed: _bookFollowup,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDoctorActions() {
    final status = widget.appointment['status'] ?? 'Pending';
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Message Patient',
                  onPressed: _messagePatient,
                  backgroundColor: Colors.white,
                  textColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: 'Start Consultation',
                  onPressed: _startConsultation,
                  backgroundColor: AppColors.consultation,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _updateStatus,
                  child: const Text('Update Status'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: _addToCalendar,
                  child: const Text('Add to Calendar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDetailCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionDetailRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox();
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'completed':
        return AppColors.info;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getHistoryIcon(String type) {
    switch (type) {
      case 'prescription':
        return Icons.medical_services;
      case 'message':
        return Icons.message;
      case 'status_change':
        return Icons.update;
      case 'payment':
        return Icons.payment;
      default:
        return Icons.history;
    }
  }

  Color _getHistoryIconColor(String type) {
    switch (type) {
      case 'prescription':
        return AppColors.prescription;
      case 'message':
        return AppColors.primary;
      case 'status_change':
        return AppColors.warning;
      case 'payment':
        return AppColors.success;
      default:
        return Colors.grey;
    }
  }

  // Action Methods
  void _joinVideoCall() {
    // Navigate to video call screen
    Navigator.pushNamed(context, '/video-call', arguments: {
      'appointmentId': widget.appointment['id'],
      'roomId': widget.appointment['roomId'],
    });
  }

  void _cancelAppointment() {
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
              // Cancel appointment logic
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _rescheduleAppointment() {
    Navigator.pushNamed(
      context,
      '/book-appointment',
      arguments: {
        'isReschedule': true,
        'appointment': widget.appointment,
      },
    );
  }

  void _downloadReceipt() {
    // Download receipt logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Receipt downloaded successfully'),
      ),
    );
  }

  void _bookFollowup() {
    Navigator.pushNamed(
      context,
      '/book-appointment',
      arguments: {
        'isFollowup': true,
        'appointment': widget.appointment,
      },
    );
  }

  void _messagePatient() {
    Navigator.pushNamed(
      context,
      '/chat',
      arguments: {
        'userId': widget.appointment['patientId'],
        'userName': widget.appointment['patientName'],
      },
    );
  }

  void _startConsultation() {
    Navigator.pushNamed(context, '/video-call', arguments: {
      'appointmentId': widget.appointment['id'],
      'roomId': widget.appointment['roomId'],
      'isDoctor': true,
    });
  }

  void _updateStatus() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Update Appointment Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...['Pending', 'Confirmed', 'In Progress', 'Completed', 'Cancelled']
                .map((status) => ListTile(
                      title: Text(status),
                      trailing: widget.appointment['status'] == status
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () {
                        // Update status logic
                        Navigator.pop(context);
                      },
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  void _addToCalendar() {
    // Add to calendar logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to calendar successfully'),
      ),
    );
  }

  void _shareAppointment() {
    // Share logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Appointment details shared'),
      ),
    );
  }

  void _printDetails() {
    // Print logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Printing...'),
      ),
    );
  }

  void _addPrescription() {
    Navigator.pushNamed(
      context,
      '/add-prescription',
      arguments: {
        'appointmentId': widget.appointment['id'],
        'patientId': widget.appointment['patientId'],
      },
    );
  }
}