import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For course type

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _courseType;
  bool _isLoading = true;

  // Mock data - Replace with API fetch later
  // Structure: { 'YYYY-MM-DD': [ {time: '09:00-10:30', module: 'Math 101', room: 'A101', instructor: 'Dr. Smith'} ] }
  Map<String, List<Map<String, String>>> _timetableData = {};

  @override
  void initState() {
    super.initState();
    _loadCourseTypeAndData();
  }

  Future<void> _loadCourseTypeAndData() async {
    final prefs = await SharedPreferences.getInstance();
    _courseType = prefs.getString('course_type') ?? 'long';

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _timetableData = {
        DateFormat('yyyy-MM-dd').format(DateTime.now()): [
          {'time': '09:00 - 10:30', 'module': 'Introduction to Maritime Logistics', 'room': 'Lecture Hall 1', 'instructor': 'Prof. Ali'},
          {'time': '11:00 - 12:30', 'module': 'Port Operations Basics', 'room': 'Room B2', 'instructor': 'Dr. Fatima'},
        ],
        DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 1))): [
          {'time': '08:30 - 10:00', 'module': 'Shipping Law', 'room': 'Seminar Room 3', 'instructor': 'Mr. Hassan'},
        ],
        // Add more for the week...
      };
      _isLoading = false;
    });

    // TODO: Real API fetch
    // e.g., http.get('/api/timetable?student_id=...&week=${_focusedDay.weekOfYear}')
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Timetable"),
        backgroundColor: const Color(0xFF003087),
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _loadCourseTypeAndData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Calendar Picker
              Card(
                margin: const EdgeInsets.all(16.0),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: TableCalendar(
                  firstDay: DateTime.utc(2023, 1, 1),
                  lastDay: DateTime.utc(2027, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarFormat: CalendarFormat.week, // Weekly view
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  availableCalendarFormats: const {CalendarFormat.week: 'Week'},
                  eventLoader: (day) {
                    final key = DateFormat('yyyy-MM-dd').format(day);
                    return _timetableData.containsKey(key) ? [_timetableData[key]!] : [];
                  },
                ),
              ),

              // Daily Schedule
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Schedule for ${DateFormat('EEEE, MMMM d').format(_selectedDay ?? _focusedDay)}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF003087)),
                ),
              ),
              const SizedBox(height: 16),

              // List of classes for the day
              ..._buildDailySchedule(_selectedDay ?? _focusedDay),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDailySchedule(DateTime day) {
    final key = DateFormat('yyyy-MM-dd').format(day);
    final schedule = _timetableData[key] ?? [];

    if (schedule.isEmpty) {
      return [
        Center(
          child: Text(
            "No classes scheduled for this day${_courseType == 'short' ? ' (Short courses may have event-based timetables)' : ''}.",
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ),
      ];
    }

    return schedule.map((entry) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF00A896),
            child: const Icon(Icons.schedule, color: Colors.white),
          ),
          title: Text(entry['module'] ?? 'Unknown Module', style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry['time'] ?? ''),
              const SizedBox(height: 4),
              Text("Room: ${entry['room'] ?? 'TBD'}"),
              Text("Instructor: ${entry['instructor'] ?? 'TBD'}"),
            ],
          ),
          onTap: () {
            // TODO: Show details or edit if instructor
          },
        ),
      );
    }).toList();
  }
}