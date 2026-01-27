import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_health_consultation/core/constants/app_colors.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  int _selectedTab = 0;
  int _selectedAppointmentFilter = 0; // 0: Today, 1: Upcoming, 2: Past
  String _selectedStatusFilter = 'All'; // All, Pending, Confirmed, Completed

  final List<Map<String, dynamic>> _appointments = [
    {
      'id': '1',
      'patientName': 'John Doe',
      'patientAge': 32,
      'patientGender': 'Male',
      'time': '09:00 AM',
      'status': 'Confirmed',
      'type': 'Clinic',
      'reason': 'General Checkup',
      'phone': '+250 788 123 456',
      'email': 'john.doe@email.com',
      'medicalHistory': ['Hypertension', 'Allergic to Penicillin'],
    },
    {
      'id': '2',
      'patientName': 'Marie Uwase',
      'patientAge': 28,
      'patientGender': 'Female',
      'time': '10:30 AM',
      'status': 'Pending',
      'type': 'Video Call',
      'reason': 'Follow-up',
      'phone': '+250 789 456 123',
      'email': 'marie.uwase@email.com',
      'medicalHistory': ['Asthma'],
    },
    {
      'id': '3',
      'patientName': 'James Nkurunziza',
      'patientAge': 45,
      'patientGender': 'Male',
      'time': '02:00 PM',
      'status': 'Confirmed',
      'type': 'Clinic',
      'reason': 'Prescription Renewal',
      'phone': '+250 787 789 012',
      'email': 'james.n@email.com',
      'medicalHistory': ['Diabetes Type 2', 'High Cholesterol'],
    },
    {
      'id': '4',
      'patientName': 'Alice Mukamana',
      'patientAge': 35,
      'patientGender': 'Female',
      'time': '03:30 PM',
      'status': 'Completed',
      'type': 'Video Call',
      'reason': 'Lab Results Review',
      'phone': '+250 788 345 678',
      'email': 'alice.m@email.com',
      'medicalHistory': ['Pregnant - 24 weeks'],
    },
  ];

  final List<Map<String, dynamic>> _quickPrescriptions = [
    {
      'name': 'Amoxicillin 500mg',
      'dosage': '1 tablet 3 times daily',
      'duration': '7 days',
      'for': 'Bacterial Infections',
    },
    {
      'name': 'Paracetamol 500mg',
      'dosage': '1-2 tablets every 6 hours',
      'duration': '3 days',
      'for': 'Fever & Pain',
    },
    {
      'name': 'Ibuprofen 400mg',
      'dosage': '1 tablet every 8 hours',
      'duration': '5 days',
      'for': 'Inflammation',
    },
    {
      'name': 'Cetirizine 10mg',
      'dosage': '1 tablet daily',
      'duration': '7 days',
      'for': 'Allergies',
    },
  ];

  final List<Map<String, dynamic>> _recentMessages = [
    {
      'patient': 'John Doe',
      'message': 'Doctor, I have a fever since yesterday',
      'time': '10:30 AM',
      'unread': true,
    },
    {
      'patient': 'Marie Uwase',
      'message': 'Thank you for the consultation',
      'time': 'Yesterday',
      'unread': false,
    },
    {
      'patient': 'James Nkurunziza',
      'message': 'Can I take the medication with food?',
      'time': '2 days ago',
      'unread': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredAppointments = _filterAppointments();

    return Scaffold(
      body: Row(
        children: [
          // Left Sidebar
          _buildSidebar(),
          
          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Bar
                _buildTopBar(),
                
                // Main Content based on selected tab
                Expanded(
                  child: _selectedTab == 0
                      ? _buildAppointmentsTab(filteredAppointments)
                      : _selectedTab == 1
                          ? _buildPatientsTab()
                          : _selectedTab == 2
                              ? _buildPrescriptionsTab()
                              : _buildAnalyticsTab(),
                ),
              ],
            ),
          ),
          
          // Right Sidebar
          _buildRightSidebar(),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 280,
      color: Colors.white,
      child: Column(
        children: [
          // Logo and User Info
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Dr. Alice Uwase',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'General Physician',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Clinic Hours: 8 AM - 5 PM',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Navigation Menu
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSidebarMenuItem(
                  icon: Icons.calendar_today,
                  label: 'Appointments',
                  isSelected: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                ),
                _buildSidebarMenuItem(
                  icon: Icons.people,
                  label: 'Patients',
                  isSelected: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1),
                ),
                _buildSidebarMenuItem(
                  icon: Icons.medical_services,
                  label: 'Prescriptions',
                  isSelected: _selectedTab == 2,
                  onTap: () => setState(() => _selectedTab = 2),
                ),
                _buildSidebarMenuItem(
                  icon: Icons.analytics,
                  label: 'Analytics',
                  isSelected: _selectedTab == 3,
                  onTap: () => setState(() => _selectedTab = 3),
                ),
                _buildSidebarMenuItem(
                  icon: Icons.message,
                  label: 'Messages',
                  badgeCount: 3,
                  onTap: () {},
                ),
                _buildSidebarMenuItem(
                  icon: Icons.schedule,
                  label: 'Schedule',
                  onTap: () {},
                ),
                const Divider(height: 32),
                _buildSidebarMenuItem(
                  icon: Icons.settings,
                  label: 'Settings',
                  onTap: () {},
                ),
                _buildSidebarMenuItem(
                  icon: Icons.help_outline,
                  label: 'Help & Support',
                  onTap: () {},
                ),
              ],
            ),
          ),
          
          // Today's Stats
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today's Stats",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        value: '8',
                        label: 'Total',
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        value: '6',
                        label: 'Confirmed',
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        value: '2',
                        label: 'Pending',
                        color: AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        value: '4',
                        label: 'Completed',
                        color: AppColors.info,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _getTabTitle(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Search Bar
          Container(
            width: 300,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search patients, appointments...',
                      hintStyle: TextStyle(fontSize: 14),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Notifications
          IconButton(
            onPressed: () {},
            icon: Badge(
              label: const Text('3'),
              child: const Icon(Icons.notifications_none),
            ),
          ),
          
          // Quick Actions
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'new_appointment',
                child: Row(
                  children: [
                    Icon(Icons.add, size: 20),
                    SizedBox(width: 8),
                    Text('New Appointment'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'send_message',
                child: Row(
                  children: [
                    Icon(Icons.message, size: 20),
                    SizedBox(width: 8),
                    Text('Send Message'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'generate_report',
                child: Row(
                  children: [
                    Icon(Icons.description, size: 20),
                    SizedBox(width: 8),
                    Text('Generate Report'),
                  ],
                ),
              ),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.add, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Quick Action',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsTab(List<Map<String, dynamic>> appointments) {
    return Column(
      children: [
        // Filters
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Date Filters
              Wrap(
                spacing: 8,
                children: ['Today', 'Upcoming', 'Past'].asMap().entries.map((entry) {
                  final index = entry.key;
                  final label = entry.value;
                  return ChoiceChip(
                    label: Text(label),
                    selected: _selectedAppointmentFilter == index,
                    onSelected: (selected) {
                      setState(() => _selectedAppointmentFilter = index);
                    },
                  );
                }).toList(),
              ),
              
              const Spacer(),
              
              // Status Filter
              DropdownButton<String>(
                value: _selectedStatusFilter,
                items: ['All', 'Pending', 'Confirmed', 'Completed']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedStatusFilter = value!);
                },
              ),
              
              const SizedBox(width: 16),
              
              // Date Picker
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.calendar_today, size: 16),
                label: const Text('Select Date'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.grey[300]!),
                ),
              ),
            ],
          ),
        ),
        
        // Appointments Table
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Table Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Patient',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Time',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Type',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Status',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Actions',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Table Rows
                  Expanded(
                    child: ListView.builder(
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final appointment = appointments[index];
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey[100]!),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Patient Info
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      appointment['patientName'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${appointment['patientAge']} yrs • ${appointment['patientGender']}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      appointment['reason'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Time
                              Expanded(
                                child: Text(
                                  appointment['time'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              
                              // Type
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: appointment['type'] == 'Video Call'
                                        ? AppColors.consultation.withOpacity(0.1)
                                        : AppColors.appointment.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    appointment['type'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: appointment['type'] == 'Video Call'
                                          ? AppColors.consultation
                                          : AppColors.appointment,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              
                              // Status
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(appointment['status'])
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    appointment['status'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _getStatusColor(appointment['status']),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              
                              // Actions
                              Expanded(
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          _viewPatientDetails(appointment),
                                      icon: const Icon(
                                        Icons.visibility,
                                        size: 20,
                                      ),
                                      tooltip: 'View Details',
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          _startConsultation(appointment),
                                      icon: const Icon(
                                        Icons.video_call,
                                        size: 20,
                                        color: AppColors.consultation,
                                      ),
                                      tooltip: 'Start Consultation',
                                    ),
                                    PopupMenuButton(
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Text('Edit Appointment'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'message',
                                          child: Text('Send Message'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'prescription',
                                          child: Text('Create Prescription'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'cancel',
                                          child: Text(
                                            'Cancel Appointment',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                      child: const Icon(
                                        Icons.more_vert,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPatientsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient Management Header
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Patient Management',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Add New Patient'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Patient List
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                final patient = _appointments[index % _appointments.length];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.primary.withOpacity(0.1),
                              child: Text(
                                patient['patientName'][0],
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    patient['patientName'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${patient['patientAge']} yrs • ${patient['patientGender']}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Last Visit: ${DateFormat('MMM dd, yyyy').format(DateTime.now().subtract(Duration(days: index * 7)))}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 4,
                          children: (patient['medicalHistory'] as List)
                              .take(2)
                              .map((condition) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      condition,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.message, size: 18),
                              tooltip: 'Message',
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.medical_services, size: 18),
                              tooltip: 'Prescription',
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.history, size: 18),
                              tooltip: 'Medical History',
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.more_vert, size: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prescription Tools Header
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Digital Prescription Tools',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('New Prescription'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Quick Templates
          const Text(
            'Quick Templates',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _quickPrescriptions.map((template) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        template['dosage'],
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'Duration: ${template['duration']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            template['for'],
                            style: const TextStyle(fontSize: 12),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: const Text('Use Template'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 24),
          const Text(
            'Recent Prescriptions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.medical_services,
                        color: AppColors.prescription),
                    title: Text('Prescription #${index + 1}'),
                    subtitle: Text('For: John Doe • ${index + 1} day(s) ago'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                          tooltip: 'Edit',
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.print),
                          tooltip: 'Print',
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share),
                          tooltip: 'Share',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Clinic Analytics',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text('Analytics dashboard will be implemented here'),
          // Add charts, graphs, and statistics here
        ],
      ),
    );
  }

  Widget _buildRightSidebar() {
    return Container(
      width: 320,
      color: Colors.grey[50],
      child: Column(
        children: [
          // Upcoming Appointments
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upcoming Today',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ..._appointments
                    .where((a) => a['status'] != 'Completed')
                    .take(3)
                    .map((appointment) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor:
                                            AppColors.primary.withOpacity(0.1),
                                        child: Text(
                                          appointment['patientName'][0],
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          appointment['patientName'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(
                                                  appointment['status'])
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          appointment['status'],
                                          style: TextStyle(
                                            color: _getStatusColor(
                                                appointment['status']),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        appointment['time'],
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(width: 16),
                                      const Icon(
                                        Icons.video_call,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        appointment['type'],
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
          
          const Divider(),
          
          // Recent Messages
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Messages',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ..._recentMessages.map((message) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        color: message['unread']
                            ? AppColors.primary.withOpacity(0.05)
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor:
                                        AppColors.primary.withOpacity(0.1),
                                    child: Text(
                                      message['patient'][0],
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      message['patient'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  if (message['unread'])
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                message['message'],
                                style: const TextStyle(fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                message['time'],
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                TextButton(
                  onPressed: () {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('View All Messages'),
                      Icon(Icons.chevron_right, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(),
          
          // Quick Stats
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick Stats',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _buildMiniStatCard('24', 'Patients This Month'),
                    _buildMiniStatCard('18', 'Prescriptions'),
                    _buildMiniStatCard('95%', 'Satisfaction Rate'),
                    _buildMiniStatCard('2.3', 'Avg. Wait Time (hrs)'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarMenuItem({
    required IconData icon,
    required String label,
    bool isSelected = false,
    int? badgeCount,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : Colors.grey,
      ),
      title: Text(label),
      trailing: badgeCount != null
          ? Badge(
              label: Text(badgeCount.toString()),
              backgroundColor: AppColors.primary,
            )
          : null,
      tileColor: isSelected ? AppColors.primary.withOpacity(0.1) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onTap: onTap,
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _filterAppointments() {
    List<Map<String, dynamic>> filtered = _appointments;

    // Filter by status
    if (_selectedStatusFilter != 'All') {
      filtered = filtered
          .where((a) => a['status'] == _selectedStatusFilter)
          .toList();
    }

    return filtered;
  }

  String _getTabTitle() {
    switch (_selectedTab) {
      case 0:
        return 'Appointments';
      case 1:
        return 'Patient Management';
      case 2:
        return 'Prescriptions';
      case 3:
        return 'Analytics';
      default:
        return 'Dashboard';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return AppColors.warning;
      case 'Confirmed':
        return AppColors.success;
      case 'Completed':
        return AppColors.info;
      default:
        return Colors.grey;
    }
  }

  void _viewPatientDetails(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Patient Details - ${appointment['patientName']}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Name'),
                subtitle: Text(appointment['patientName']),
              ),
              ListTile(
                leading: const Icon(Icons.cake),
                title: const Text('Age & Gender'),
                subtitle: Text(
                    '${appointment['patientAge']} years, ${appointment['patientGender']}'),
              ),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Phone'),
                subtitle: Text(appointment['phone']),
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email'),
                subtitle: Text(appointment['email']),
              ),
              const Divider(),
              const Text('Medical History:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...(appointment['medicalHistory'] as List).map((condition) =>
                  Text('• $condition', style: const TextStyle(fontSize: 14))),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('View Full Profile'),
          ),
        ],
      ),
    );
  }

  void _startConsultation(Map<String, dynamic> appointment) {
    // Navigate to video consultation screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Consultation'),
        content: Text(
            'Start ${appointment['type']} consultation with ${appointment['patientName']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to video consultation screen
              // Navigator.push(context, MaterialPageRoute(builder: (context) => VideoCallScreen()));
            },
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }
}