import 'package:flutter/material.dart';

class CommunityTabBar extends StatelessWidget {
  final String selectedTab;
  final Function(String) onTabSelected;

  const CommunityTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 51,
        width: 300,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.2),
              spreadRadius: 0,
              blurRadius: 5,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTabButton('all'),
              _buildTabButton('low'),
              _buildTabButton('moderate'),
              _buildTabButton('high'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String tabName) {
    bool isSelected = selectedTab.toLowerCase() == tabName.toLowerCase();

    return GestureDetector(
      onTap: () => onTabSelected(tabName),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromRGBO(106, 149, 122, 1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          tabName[0].toUpperCase() +
              tabName.substring(1), // Capitalize first letter
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? Colors.white : const Color.fromRGBO(176, 176, 176, 1),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
