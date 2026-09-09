import 'package:get/get.dart';
import 'package:edutrack/features/authentication/screens/login/login_screen.dart';
import 'package:edutrack/features/authentication/screens/sign_up/sign_up_screen.dart';
import 'package:edutrack/features/authentication/screens/forget_password/forgot_password_screen.dart';
import 'package:edutrack/features/authentication/screens/splash/splash_screen.dart';
import 'package:edutrack/features/student/screens/dashboard/student_dashboard_screen.dart';
import 'package:edutrack/features/student/screens/courses/student_courses_screen.dart';
import 'package:edutrack/features/student/screens/course_details/student_course_details_screen.dart';
import 'package:edutrack/features/student/screens/attendance_history/student_attendance_history_screen.dart';
import 'package:edutrack/features/student/screens/ct_marks/student_ct_marks_screen.dart';
import 'package:edutrack/features/student/screens/routine/routine_screen.dart';
import 'package:edutrack/features/teacher/screens/dashboard/teacher_dashboard_screen.dart';
import 'package:edutrack/features/teacher/screens/courses/teacher_courses_screen.dart';
import 'package:edutrack/features/teacher/screens/course_details/teacher_course_details_screen.dart';
import 'package:edutrack/features/teacher/screens/attendance/take_attendance_screen.dart';
import 'package:edutrack/features/teacher/screens/attendance/attendance_history_screen.dart';
import 'package:edutrack/features/teacher/screens/ct_marks/teacher_ct_marks_screen.dart';
import 'package:edutrack/features/teacher/screens/ct_marks/upload_ct_marks_screen.dart';
import 'package:edutrack/features/personalization/screens/profile/profile_screen.dart';
import 'package:edutrack/features/personalization/screens/profile/edit_profile_screen.dart';

class AppRoutes {
  // Splash Route
  static const String splash = '/splash';

  // Auth Routes
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String forgotPassword = '/forgot-password';

  // Student Routes
  static const String studentDashboard = '/student-dashboard';
  static const String studentCourses = '/student-courses';
  static const String studentTodaysClasses = '/student-todays-classes';
  static const String studentCourseDetails = '/student-course-details';
  static const String studentAttendanceHistory = '/student-attendance-history';
  static const String studentCtMarks = '/student-ct-marks';
  static const String studentRoutine = '/student-routine';
  static const String studentProfile = '/student-profile';

  // Teacher Routes
  static const String teacherDashboard = '/teacher-dashboard';
  static const String teacherCourses = '/teacher-courses';
  static const String teacherTodaysClasses = '/teacher-todays-classes';
  static const String teacherCourseDetails = '/teacher-course-details';
  static const String takeAttendance = '/take-attendance';
  static const String attendanceHistory = '/attendance-history';
  static const String teacherCtMarks = '/teacher-ct-marks';
  static const String uploadCtMarks = '/upload-ct-marks';
  static const String teacherRoutine = '/teacher-routine';
  static const String teacherProfile = '/teacher-profile';

  // Common Routes
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';

  static final List<GetPage> pages = [
    // Splash
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),

    // Auth Routes
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

    // Student Routes
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
      page: () => const RoutineScreen(userRole: 'student'),
    ),
    GetPage(
      name: studentProfile,
      page: () => const ProfileScreen(userRole: 'student'),
    ),

    // Teacher Routes
    GetPage(
      name: teacherDashboard,
      page: () => const TeacherDashboardScreen(),
    ),
    GetPage(
      name: teacherCourses,
      page: () => const TeacherCoursesScreen(showTodayOnly: false),
    ),
    GetPage(
      name: teacherTodaysClasses,
      page: () => const TeacherCoursesScreen(showTodayOnly: true),
    ),
    GetPage(
      name: teacherCourseDetails,
      page: () => const TeacherCourseDetailsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: takeAttendance,
      page: () => const TakeAttendanceScreen(
        courseCode: 'CSE 356',
        courseName: 'Software Engineering',
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: attendanceHistory,
      page: () => const AttendanceHistoryScreen(
        courseCode: 'CSE 356',
        courseName: 'Software Engineering',
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: teacherCtMarks,
      page: () => const TeacherCtMarksScreen(
        courseCode: 'CSE 356',
        courseName: 'Software Engineering',
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: uploadCtMarks,
      page: () => const UploadCtMarksScreen(
        courseCode: 'CSE 356',
        courseName: 'Software Engineering',
        ctTitle: 'CT-2',
        fullMarks: 20,
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: teacherRoutine,
      page: () => const RoutineScreen(userRole: 'teacher'),
    ),
    GetPage(
      name: teacherProfile,
      page: () => const ProfileScreen(userRole: 'teacher'),
    ),

    // Common Routes
    GetPage(
      name: profile,
      page: () => const ProfileScreen(userRole: 'student'),
    ),
    GetPage(
      name: editProfile,
      page: () => const EditProfileScreen(),
    ),
  ];
}