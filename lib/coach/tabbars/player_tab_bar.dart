import 'package:flutter/material.dart';

class PlayerTabBar extends StatelessWidget {
  final String? selectedTab;
  final Function(String) onTabSelected;

  const PlayerTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 51,
        width: 310,
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
              _buildTabButton('missed'),
              _buildTabButton('achievements'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String tabName) {
    final String selected = selectedTab?.toLowerCase() ?? 'all';
    final bool isSelected = selected == tabName.toLowerCase();

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
          tabName[0].toUpperCase() + tabName.substring(1),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? Colors.white
                : const Color.fromRGBO(176, 176, 176, 1),
          ),
        ),
      ),
    );
  }
}
