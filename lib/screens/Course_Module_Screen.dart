import 'package:flutter/material.dart';

class ModuleDetailScreen extends StatelessWidget {
  final Map<String, dynamic> module;

  const ModuleDetailScreen({
    super.key,
    required this.module,
  });

  @override
  Widget build(BuildContext context) {
    final String code = module['code'] ?? 'N/A';
    final String name = module['name'] ?? 'Unknown Module';
    final int credits = module['credits'] ?? 0;
    final String instructor = module['instructor'] ?? 'Not Assigned';
    final String status = module['status'] ?? 'Unknown';
    final String description = module['description'] ?? 'No description available.';
    final String objectives = module['objectives'] ?? 'No objectives listed.';

    final Color statusColor = status == 'Ongoing'
        ? Colors.blue
        : status == 'Completed'
        ? Colors.green
        : status == 'Upcoming'
        ? Colors.orange
        : Colors.grey;

    return Scaffold(
      appBar: AppBar(
        title: Text('$code - $name'),
        backgroundColor: const Color(0xFF003087),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003087),
                            ),
                          ),
                        ),
                        Chip(
                          label: Text(status),
                          backgroundColor: statusColor,
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$code • $credits Credits',
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.person, color: Color(0xFF00A896), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Instructor: $instructor',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Description Section
            _buildSectionCard(
              title: 'Module Description',
              content: description,
              icon: Icons.description,
            ),

            const SizedBox(height: 16),

            // Learning Objectives
            _buildSectionCard(
              title: 'Learning Objectives',
              content: objectives,
              icon: Icons.track_changes,
            ),

            const SizedBox(height: 24),

            // Action Buttons
            const Text(
              'Resources & Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003087),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.book,
                    label: 'View Notes / Lectures',
                    color: Colors.blue,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening notes... (coming soon)')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.assignment,
                    label: 'Assignments',
                    color: Colors.orange,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Assignments section (coming soon)')),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.grade,
                    label: 'Module Results',
                    color: Colors.green,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Showing results for this module...')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.checklist,
                    label: 'Attendance',
                    color: Colors.purple,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Attendance record (coming soon)')),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF00A896)),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003087),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      icon: Icon(icon, color: color),
      label: Text(label, style: TextStyle(color: color)),
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}