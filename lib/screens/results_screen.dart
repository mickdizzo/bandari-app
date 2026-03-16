import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  String? _courseType;
  bool _isLoading = true;
  String _selectedSemester = '2024/2025 - Semester 1'; // Default

  // Mock data - Replace with real API response
  Map<String, Map<String, dynamic>> _resultsData = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _courseType = prefs.getString('course_type') ?? 'long';
    });

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _resultsData = {
        '2024/2025 - Semester 1': {
          'gpa': 3.8,
          'credits': 18,
          'status': 'Pass',
          'modules': [
            {
              'code': 'MAR101',
              'name': 'Maritime Logistics Intro',
              'ca': 38,           // Continuous Assessment - example value
              'credits': 4,
              'marks': 85,
              'grade': 'A',
            },
            {
              'code': 'POR201',
              'name': 'Port Operations',
              'ca': 32,
              'credits': 3,
              'marks': 72,
              'grade': 'B+',
            },
            {
              'code': 'ENG301',
              'name': 'English for Maritime',
              'ca': 30,
              'credits': 3,
              'marks': 68,
              'grade': 'B',
            },
            {
              'code': 'MATH101',
              'name': 'Mathematics for Ports',
              'ca': 40,
              'credits': 4,
              'marks': 91,
              'grade': 'A+',
            },
          ],
        },
        '2023/2024 - Semester 2': {
          'gpa': 3.5,
          'credits': 15,
          'status': 'Pass',
          'modules': [
            {
              'code': 'SHIP101',
              'name': 'Shipping Law Basics',
              'ca': 35,
              'credits': 3,
              'marks': 78,
              'grade': 'B+',
            },
            {
              'code': 'SAFE201',
              'name': 'Safety & Security',
              'ca': 36,
              'credits': 4,
              'marks': 82,
              'grade': 'A-',
            },
          ],
        },
      };
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentResults = _resultsData[_selectedSemester] ?? {'modules': []};
    final modules = currentResults['modules'] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Results"),
        backgroundColor: const Color(0xFF003087),
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Semester Selector & Summary
              Card(
                margin: const EdgeInsets.all(16),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Academic Summary",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF003087)),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedSemester,
                        decoration: const InputDecoration(
                          labelText: "Select Semester",
                          border: OutlineInputBorder(),
                        ),
                        items: _resultsData.keys
                            .map((sem) => DropdownMenuItem(value: sem, child: Text(sem)))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) setState(() => _selectedSemester = value);
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSummaryItem("GPA", currentResults['gpa']?.toStringAsFixed(2) ?? "N/A", Colors.green),
                          _buildSummaryItem("Credits", currentResults['credits']?.toString() ?? "0", Colors.blue),
                          _buildSummaryItem(
                            "Status",
                            currentResults['status'] ?? "Pending",
                            currentResults['status'] == 'Pass' ? Colors.green : Colors.orange,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Module Results Table
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Text(
                  "Module Results",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003087)),
                ),
              ),
              const SizedBox(height: 12),

              if (modules.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(
                      "No results available for this semester yet.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DataTable(
                    columnSpacing: 20,
                    headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
                    dataRowColor: MaterialStateProperty.resolveWith((states) {
                      return states.contains(MaterialState.selected)
                          ? Colors.blue.shade50
                          : null;
                    }),
                    columns: const [
                      DataColumn(label: Text('Module', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Course No', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('CA', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Credit', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Marks', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Grade', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: modules.map<DataRow>((module) {
                      final double marks = (module['marks'] as num?)?.toDouble() ?? 0;
                      final String grade = module['grade'] ?? '?';
                      final String status = marks >= 50 ? 'Pass' : 'Fail';

                      final Color gradeColor = marks >= 80
                          ? Colors.green
                          : marks >= 60
                          ? Colors.blue
                          : marks >= 50
                          ? Colors.orange
                          : Colors.red;

                      return DataRow(
                        cells: [
                          DataCell(Text(module['name'] ?? 'Unknown')),
                          DataCell(Text(module['code'] ?? '-')),
                          DataCell(Text(module['ca']?.toString() ?? '-')),
                          DataCell(Text(module['credits']?.toString() ?? '-')),
                          DataCell(
                            Text(
                              "${module['marks'] ?? '-'}%",
                              style: TextStyle(color: gradeColor, fontWeight: FontWeight.w600),
                            ),
                          ),
                          DataCell(
                            Text(
                              grade,
                              style: TextStyle(color: gradeColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataCell(
                            Text(
                              status,
                              style: TextStyle(
                                color: status == 'Pass' ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),

              const SizedBox(height: 24),

              if (_courseType == 'long')
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.description),
                    label: const Text("View Full Transcript"),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Transcript feature coming soon!")),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFF003087)),
                    ),
                  ),
                ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
      ],
    );
  }
}