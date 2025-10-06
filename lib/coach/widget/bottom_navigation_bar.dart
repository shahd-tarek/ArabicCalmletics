import 'package:calmleticsarab/constant.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem('assets/images/home.png', " الرئيسية", 0),
            _buildNavItem('assets/images/Group.png', "VR جلسات", 1),
            _buildNavItem(
              'assets/images/tabler_play-football.png',
              "اللاعبون",
              2,
            ),
            _buildNavItem('assets/images/people.png', "المجتمع", 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String imagePath, String label, int index) {
    final bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            width: 24,
            height: 24,
            color: isSelected
                ? const Color.fromRGBO(106, 149, 122, 1)
                : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? kPrimaryColor : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
