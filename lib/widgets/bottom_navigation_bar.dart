import 'package:flutter/material.dart';
import 'package:calmleticsarab/constant.dart';

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
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(Icons.home, "Home", 0),
            const SizedBox(width: 10),
            _buildNavItem(Icons.vrpano, "Session", 1),
            const SizedBox(width: 40),
            _buildNavItem(Icons.bar_chart, "Progress", 2),
            _buildNavItem(Icons.people, "Community", 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28,
            color:
                isSelected
                    ? kPrimaryColor
                    : const Color.fromRGBO(200, 200, 200, 1),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color:
                  isSelected
                      ? kPrimaryColor
                      : const Color.fromRGBO(200, 200, 200, 1),
            ),
          ),
        ],
      ),
    );
  }
}
