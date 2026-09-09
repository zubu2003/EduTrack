import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/routes/app_routes.dart';
import 'package:iconsax/iconsax.dart';

class TeacherBottomNav extends StatelessWidget {
  final int currentIndex;

  const TeacherBottomNav({
    super.key,
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SColors.white,
        boxShadow: [
          BoxShadow(
            color: SColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: SColors.white,
        selectedItemColor: SColors.primary,
        unselectedItemColor: SColors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == currentIndex) return;

          switch (index) {
            case 0:
              Get.offAllNamed(AppRoutes.teacherDashboard);
              break;
            case 1:
              Get.offAllNamed(AppRoutes.teacherCourses);
              break;
            case 2:
              Get.snackbar(
                'Coming Soon',
                'Routine feature coming soon!',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 2),
              );
              break;
            case 3:
              Get.offAllNamed(AppRoutes.teacherProfile);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.book),
            label: 'Course',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.calendar),
            label: 'Routine',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.user),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}