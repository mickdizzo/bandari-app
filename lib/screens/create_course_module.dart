import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_screen.dart'; // we'll create next

class CourseTypeSelectionScreen extends StatefulWidget {
  const CourseTypeSelectionScreen({super.key});

  @override
  State<CourseTypeSelectionScreen> createState() => _CourseTypeSelectionScreenState();
}

class _CourseTypeSelectionScreenState extends State<CourseTypeSelectionScreen> {
  String? _selectedType;

  Future<void> _saveAndProceed() async {
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select your course type")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('course_type', _selectedType!);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Your Course Type"),
        backgroundColor: const Color(0xFF003087),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Welcome to Bandari Student Portal!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF003087)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "Please select whether you're enrolled in a Short Course or Long Course program.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Card for Short Course
              GestureDetector(
                onTap: () => setState(() => _selectedType = "short"),
                child: Card(
                  elevation: _selectedType == "short" ? 8 : 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: _selectedType == "short" ? const Color(0xFF00A896).withOpacity(0.1) : null,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Icon(Icons.school_outlined, size: 48, color: Color(0xFF003087)),
                        const SizedBox(height: 12),
                        const Text(
                          "Short Course",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Quick registration, published courses, apply online",
                          style: TextStyle(color: Colors.grey.shade700),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Card for Long Course
              GestureDetector(
                onTap: () => setState(() => _selectedType = "long"),
                child: Card(
                  elevation: _selectedType == "long" ? 8 : 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: _selectedType == "long" ? const Color(0xFF00A896).withOpacity(0.1) : null,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Icon(Icons.menu_book_outlined, size: 48, color: Color(0xFF003087)),
                        const SizedBox(height: 12),
                        const Text(
                          "Long Course",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Timetable, modules, notes, results, payments, attendance",
                          style: TextStyle(color: Colors.grey.shade700),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 48),

              ElevatedButton(
                onPressed: _saveAndProceed,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Continue", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}