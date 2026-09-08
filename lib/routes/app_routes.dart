import 'package:get/get.dart';
import 'package:edutrack/features/authentication/screens/login/login_screen.dart';
import 'package:edutrack/features/authentication/screens/sign_up/sign_up_screen.dart';
import 'package:edutrack/features/authentication/screens/forget_password/forgot_password_screen.dart';
import 'package:edutrack/features/student/screens/dashboard/student_dashboard_screen.dart';
import 'package:edutrack/features/student/screens/courses/student_courses_screen.dart';
import 'package:edutrack/features/student/screens/course_details/student_course_details_screen.dart';
import 'package:edutrack/features/student/screens/attendance_history/student_attendance_history_screen.dart';
import 'package:edutrack/features/student/screens/ct_marks/student_ct_marks_screen.dart';
import 'package:edutrack/features/student/screens/routine/student_routine_screen.dart';
import 'package:edutrack/features/personalization/screens/profile/profile_screen.dart';
import 'package:edutrack/features/personalization/screens/profile/edit_profile_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String studentDashboard = '/student-dashboard';
  static const String studentCourses = '/student-courses';
  static const String studentTodaysClasses = '/student-todays-classes';
  static const String studentCourseDetails = '/student-course-details';
  static const String studentAttendanceHistory = '/student-attendance-history';
  static const String studentCtMarks = '/student-ct-marks';
  static const String studentRoutine = '/student-routine';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';

  static final List<GetPage> pages = [
    GetPage(
      name: login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: signUp,
      page: () => const SignUpScreen(),
    ),
    GetPage(
      name: forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: studentDashboard,
      page: () => const StudentDashboardScreen(),
    ),
    GetPage(
      name: studentCourses,
      page: () => const StudentCoursesScreen(showTodayOnly: false),
    ),
    GetPage(
      name: studentTodaysClasses,
      page: () => const StudentCoursesScreen(showTodayOnly: true),
    ),
    GetPage(
      name: studentCourseDetails,
      page: () => const StudentCourseDetailsScreen(
        courseCode: 'CSE 356',
        courseName: 'Software Engineering',
      ),
    ),
    GetPage(
      name: studentAttendanceHistory,
      page: () => const StudentAttendanceHistoryScreen(
        courseCode: 'CSE 356',
        courseName: 'Software Engineering',
      ),
    ),
    GetPage(
      name: studentCtMarks,
      page: () => const StudentCtMarksScreen(
        courseCode: 'CSE 356',
        courseName: 'Software Engineering',
      ),
    ),
    GetPage(
      name: studentRoutine,
      page: () => const StudentRoutineScreen(),
    ),
    GetPage(
      name: profile,
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: editProfile,
      page: () => const EditProfileScreen(),
    ),
  ];
}