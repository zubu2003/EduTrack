import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:iconsax/iconsax.dart';

class DashboardBottomNav extends StatelessWidget {
  const DashboardBottomNav({super.key});

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
        currentIndex: 0,
        onTap: (index) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Navigation to tab ${index + 1}'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.calendar),
            label: 'Routine',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.clipboard),
            label: 'Attendance',
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