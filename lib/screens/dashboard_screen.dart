import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'timetable_screen.dart';
import 'profile_screen.dart';
import 'results_screen.dart';
import 'payment_details_screen.dart';
import 'Course_Module_Screen.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? _courseType;

  @override
  void initState() {
    super.initState();
    _loadCourseType();
  }

  Future<void> _loadCourseType() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _courseType = prefs.getString('course_type') ?? 'unknown';
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLongCourse = _courseType == 'long';
    final bool isShortCourse = _courseType == 'short';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bandari Dashboard"),
        backgroundColor: const Color(0xFF003087),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // You can add real refresh logic here later (API calls)
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) {
            setState(() {}); // just to trigger rebuild for demo
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Welcome Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back!",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: const Color(0xFF003087),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "You're viewing as ${_courseType == 'unknown' ? 'a' : _courseType} course student",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Quick Access Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildDashboardCard(
                  icon: Icons.calendar_today,
                  title: "Timetable",
                  color: Colors.blue,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TimetableScreen()),
                  ),
                ),
                _buildDashboardCard(
                  icon: Icons.grade,
                  title: "Results",
                  color: Colors.green,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ResultsScreen()),
                  ),
                ),
                _buildDashboardCard(
                  icon: Icons.book,
                  title: isShortCourse ? "Published Courses" : "Course Modules",
                  color: Colors.orange,
                  onTap: () {
                    // For now we use the same screen → later you can split
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ModuleDetailScreen(module: currentModules[index])),
                    );
                  },
                ),
                if (isLongCourse)
                  _buildDashboardCard(
                    icon: Icons.attach_money,
                    title: "Payments",
                    color: Colors.purple,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PaymentDetailsScreen()),
                    ),
                  ),
                if (isShortCourse)
                  _buildDashboardCard(
                    icon: Icons.how_to_reg,
                    title: "Apply / Register",
                    color: Colors.teal,
                    onTap: () {
                      // TODO: Create and navigate to Apply / Published Courses screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Apply feature coming soon")),
                      );
                    },
                  ),
                _buildDashboardCard(
                  icon: Icons.person_outline,
                  title: "Profile",
                  color: Colors.indigo,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Announcements / Quick Links
            Card(
              child: ListTile(
                leading: const Icon(Icons.notifications_active, color: Colors.red),
                title: const Text("Check for new announcements"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: Announcements screen or dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Announcements coming soon")),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Schedule"),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Courses"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        selectedItemColor: const Color(0xFF003087),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          // You can implement full navigation here later (e.g. using go_router or indexed stack)
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          }
          // other indices can be implemented similarly
        },
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}