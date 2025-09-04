// leaderboard_tab_bar.dart
import 'package:flutter/material.dart';

class LeaderboardTabBar extends StatelessWidget {
  final String selectedTab;
  final Function(String) onTabSelected;

  const LeaderboardTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            _buildTabButton('Daily'),
            _buildTabButton('Weekly'),
            _buildTabButton('All'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String tabName) {
    bool isSelected = selectedTab == tabName;

    return GestureDetector(
      onTap: () => onTabSelected(tabName),
      child: Container(
        width: 80,
        height: 35,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromRGBO(106, 149, 122, 1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            tabName,
            style: TextStyle(
              fontSize: 16,
              color:
                  isSelected ? Colors.white : const Color.fromRGBO(176, 176, 176, 1),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
