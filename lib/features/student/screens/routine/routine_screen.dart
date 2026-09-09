import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/common/widget/bottom_nav/student_bottom_nav.dart';
import 'package:edutrack/common/widget/bottom_nav/teacher_bottom_nav.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'add_routine_screen.dart';
import 'widgets/routine_header.dart';
import 'widgets/routine_day_tabs.dart';
import 'widgets/routine_card.dart';

class RoutineScreen extends StatefulWidget {
  final String userRole; // 'student' or 'teacher'

  const RoutineScreen({
    super.key,
    this.userRole = 'student',
  });

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  String selectedDay = 'Sun';

  // Hardcoded routine data
  final Map<String, List<Map<String, dynamic>>> routineData = {
    'Sun': [
      {
        'startTime': '10:00 AM',
        'endTime': '11:00 AM',
        'courseCode': 'CSE 356',
        'courseName': 'Advanced AI Principles',
        'room': 'Room 301',
        'teacher': 'Dr. Alan T.',
        'color': SColors.primary,
      },
    ],
    'Mon': [
      {
        'startTime': '01:00 PM',
        'endTime': '02:30 PM',
        'courseCode': 'MAT 201',
        'courseName': 'Linear Algebra & Logic',
        'room': 'Hall 104',
        'teacher': 'Prof. Smith',
        'color': SColors.success,
      },
      {
        'startTime': '03:30 PM',
        'endTime': '05:00 PM',
        'courseCode': 'HUM 102',
        'courseName': 'Ethics in Technology',
        'room': 'Seminar B',
        'teacher': 'Dr. Johnson',
        'color': SColors.warning,
      },
    ],
    'Tue': [
      {
        'startTime': '09:00 AM',
        'endTime': '10:30 AM',
        'courseCode': 'CSE 356',
        'courseName': 'Advanced AI Principles',
        'room': 'Room 301',
        'teacher': 'Dr. Alan T.',
        'color': SColors.primary,
      },
    ],
    'Wed': [
      {
        'startTime': '11:00 AM',
        'endTime': '12:30 PM',
        'courseCode': 'MAT 201',
        'courseName': 'Linear Algebra & Logic',
        'room': 'Hall 104',
        'teacher': 'Prof. Smith',
        'color': SColors.success,
      },
    ],
    'Thu': [
      {
        'startTime': '02:00 PM',
        'endTime': '03:30 PM',
        'courseCode': 'HUM 102',
        'courseName': 'Ethics in Technology',
        'room': 'Seminar B',
        'teacher': 'Dr. Johnson',
        'color': SColors.warning,
      },
    ],
  };

  final List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu'];

  void _openEditScreen(String day, int index) {
    final routine = routineData[day]![index];
    Get.to(
          () => AddRoutineScreen(
        day: day,
        routine: routine,
        index: index,
      ),
    );
  }

  void _openAddScreen() {
    Get.to(
          () => AddRoutineScreen(
        day: selectedDay,
        routine: null,
        index: -1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentRoutines = routineData[selectedDay] ?? [];

    // Determine bottom nav based on role
    final bottomNav = widget.userRole == 'teacher'
        ? const TeacherBottomNav(currentIndex: 2)
        : const StudentBottomNav(currentIndex: 2);

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: const SAppbar(
        showBackButton: false,
      ),
      body: Column(
        children: [
          // Header
          const RoutineHeader(),

          const SizedBox(height: SSize.spaceBtwItems),

          // Day Tabs
          RoutineDayTabs(
            days: days,
            selectedDay: selectedDay,
            onDaySelected: (day) {
              setState(() {
                selectedDay = day;
              });
            },
          ),

          const SizedBox(height: SSize.spaceBtwItems),

          // Routine List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: SSize.defaultSpace),
              child: currentRoutines.isEmpty
                  ? const Center(
                child: Text(
                  'No classes on this day',
                  style: TextStyle(
                    color: SColors.textSecondary,
                    fontSize: SSize.fontSizeMd,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: currentRoutines.length,
                itemBuilder: (context, index) {
                  final routine = currentRoutines[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: SSize.spaceBtwItems),
                    child: RoutineCard(
                      startTime: routine['startTime']!,
                      endTime: routine['endTime']!,
                      courseCode: routine['courseCode']!,
                      courseName: routine['courseName']!,
                      room: routine['room']!,
                      teacher: routine['teacher']!,
                      color: routine['color'] as Color,
                      onTap: () {
                        _openEditScreen(selectedDay, index);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomNav,
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddScreen,
        backgroundColor: SColors.primary,
        elevation: 4,
        child: const Icon(
          Icons.add,
          color: SColors.white,
          size: 28,
        ),
      ),
    );
  }
}