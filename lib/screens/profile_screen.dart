import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_text_field.dart'; // Reuse from login/register

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  String? _courseType;
  bool _isLoading = true;

  // Controllers for editable fields
  final _fullNameController = TextEditingController();
  final _emailOrPhoneController = TextEditingController();

  // Mock data - Replace with real API fetch later
  String _fullName = 'John Mwangi';
  String _studentId = 'BC/2024/001';
  String _emailOrPhone = 'john@bandari.ac.tz';
  String _joinedDate = 'October 31, 2023';
  String _program = 'Diploma in Maritime Transport and Logistics Management'; // Example for Bandari College
  String _dateOfBirth = '15 May 2002';
  String _sex = 'Male';
  String _nationality = 'Tanzanian';
  String _currentSemester = '2025/2026 - Semester 1';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _courseType = prefs.getString('course_type') ?? 'long';

      // TODO: Fetch real profile from API
      // e.g., final response = await http.get('/api/profile');
      // Then parse: _fullName = data['full_name']; _program = data['program']; etc.

      // Set controllers for editable fields
      _fullNameController.text = _fullName;
      _emailOrPhoneController.text = _emailOrPhone;

      _isLoading = false;
    });
  }

  Future<void> _saveChanges() async {
    if (_fullNameController.text.trim().isEmpty ||
        _emailOrPhoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields")),
      );
      return;
    }

    setState(() {
      _fullName = _fullNameController.text.trim();
      _emailOrPhone = _emailOrPhoneController.text.trim();
      _isEditing = false;
    });

    // TODO: Send update to API (only editable fields)
    // http.post('/api/profile/update', body: {
    //   'full_name': _fullName,
    //   'email_or_phone': _emailOrPhone,
    // })
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: const Color(0xFF003087),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.cancel : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
                if (!_isEditing) {
                  // Reset editable fields if canceled
                  _fullNameController.text = _fullName;
                  _emailOrPhoneController.text = _emailOrPhone;
                }
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar Header
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: const Color(0xFF00A896),
                      child: const Icon(Icons.person, size: 80, color: Colors.white),
                      // TODO: Use NetworkImage(backgroundImage: NetworkImage(_photoUrl ?? '')) for real photo
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, color: Color(0xFF003087)),
                            onPressed: () {
                              // TODO: Implement image picker & upload
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _fullName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF003087)),
              ),
              const SizedBox(height: 8),
              Text(
                '$_courseType Course Student • $_currentSemester',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),

              const SizedBox(height: 32),

              // Info Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Personal Information",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003087)),
                      ),
                      const SizedBox(height: 16),

                      _buildInfoRow(
                        icon: Icons.person,
                        label: "Full Name",
                        value: _fullName,
                        child: _isEditing
                            ? CustomTextField(
                          label: "Full Name",
                          controller: _fullNameController,
                        )
                            : null,
                      ),

                      const Divider(height: 24),

                      _buildInfoRow(
                        icon: Icons.badge,
                        label: "Student ID",
                        value: _studentId,
                      ),

                      const Divider(height: 24),

                      _buildInfoRow(
                        icon: Icons.school,
                        label: "Program",
                        value: _program,
                      ),

                      const Divider(height: 24),

                      _buildInfoRow(
                        icon: Icons.calendar_today,
                        label: "Date of Birth",
                        value: _dateOfBirth,
                      ),

                      const Divider(height: 24),

                      _buildInfoRow(
                        icon: Icons.wc,
                        label: "Sex",
                        value: _sex,
                      ),

                      const Divider(height: 24),

                      _buildInfoRow(
                        icon: Icons.public,
                        label: "Nationality",
                        value: _nationality,
                      ),

                      const Divider(height: 24),

                      _buildInfoRow(
                        icon: Icons.email,
                        label: "Email / Phone",
                        value: _emailOrPhone,
                        child: _isEditing
                            ? CustomTextField(
                          label: "Email or Phone",
                          controller: _emailOrPhoneController,
                        )
                            : null,
                      ),

                      const Divider(height: 24),

                      _buildInfoRow(
                        icon: Icons.calendar_month,
                        label: "Joined Date",
                        value: _joinedDate,
                      ),

                      const Divider(height: 24),

                      _buildInfoRow(
                        icon: Icons.date_range,
                        label: "Current Semester",
                        value: _currentSemester,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Actions
              if (_isEditing)
                ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Save Changes", style: TextStyle(fontSize: 18)),
                )
              else
                Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.lock, color: Color(0xFF003087)),
                      title: const Text("Change Password"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // TODO: Navigate to change password screen
                      },
                    ),
                    if (_courseType == 'long')
                      ListTile(
                        leading: const Icon(Icons.description, color: Color(0xFF003087)),
                        title: const Text("View Transcripts"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // TODO: Transcripts screen
                        },
                      ),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text("Logout", style: TextStyle(color: Colors.red)),
                      onTap: () {
                        // TODO: Clear auth token, shared prefs, navigate to login
                        // For now: simulate
                        Navigator.pushReplacementNamed(context, '/login'); // Adjust to your route name
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Widget? child,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF00A896), size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              const SizedBox(height: 4),
              if (child != null)
                child
              else
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailOrPhoneController.dispose();
    super.dispose();
  }
}