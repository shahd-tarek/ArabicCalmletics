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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem('assets/images/home.png', "Home", 0),
            const SizedBox(width: 10),
            _buildNavItem('assets/images/Group.png', "VR Session", 1),
            const SizedBox(width: 40), 
            _buildNavItem('assets/images/tabler_play-football.png', "Players", 2),
            _buildNavItem('assets/images/people.png', "Community",  3),
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
            color: isSelected ? const Color.fromRGBO(106, 149, 122, 1) : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color.fromRGBO(106, 149, 122, 1) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
