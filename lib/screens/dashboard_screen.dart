import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bandari Dashboard"),
        backgroundColor: const Color(0xFF003087),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // TODO: Go to Profile screen
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Fetch fresh data from API later
          await Future.delayed(const Duration(seconds: 1));
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
                      "You're viewing as $_courseType course student",
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
                  onTap: () {
                    // TODO: Navigate to Timetable screen
                  },
                ),
                _buildDashboardCard(
                  icon: Icons.grade,
                  title: "Results",
                  color: Colors.green,
                  onTap: () {
                    // TODO: Navigate to Results screen
                  },
                ),
                _buildDashboardCard(
                  icon: Icons.book,
                  title: _courseType == "short" ? "Published Courses" : "Course Modules",
                  color: Colors.orange,
                  onTap: () {
                    // TODO: Courses / Modules screen
                  },
                ),
                _buildDashboardCard(
                  icon: Icons.attach_money,
                  title: "Payments",
                  color: Colors.purple,
                  show: _courseType == "long", // only for long course
                  onTap: () {
                    // TODO: Payments screen
                  },
                ),
                _buildDashboardCard(
                  icon: Icons.how_to_reg,
                  title: "Apply / Register",
                  color: Colors.teal,
                  show: _courseType == "short", // more for short course
                  onTap: () {
                    // TODO: Apply screen
                  },
                ),
                _buildDashboardCard(
                  icon: Icons.person_outline,
                  title: "Profile",
                  color: Colors.indigo,
                  onTap: () {
                    // TODO: Profile screen
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Optional: Upcoming events or quick links
            Card(
              child: ListTile(
                leading: const Icon(Icons.notifications_active, color: Colors.red),
                title: const Text("Check for new announcements"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: Announcements or notifications
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
        currentIndex: 0, // Home
        onTap: (index) {
          // TODO: Handle navigation
        },
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required Color color,
    VoidCallback? onTap,
    bool show = true,
  }) {
    if (!show) return const SizedBox.shrink();

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
              ),
            ],
          ),
        ),
      ),
    );
  }
}