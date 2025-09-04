import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final String? selectedLevel;
  final Function(String) onTabSelected;

  const CustomTabBar({
    super.key,
    required this.selectedLevel,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            spreadRadius: 4,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTabButton('Low'),
            _buildTabButton('Moderate'),
            _buildTabButton('High'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String tabName) {
    final bool isSelected = selectedLevel == tabName;

    return GestureDetector(
      onTap: () => onTabSelected(tabName),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromRGBO(106, 149, 122, 1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          tabName,
          style: TextStyle(
            fontSize: 16,
            color: isSelected
                ? Colors.white
                : const Color.fromRGBO(176, 176, 176, 1),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
