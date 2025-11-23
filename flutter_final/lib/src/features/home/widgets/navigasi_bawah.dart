import 'package:flutter/material.dart';

class NavigasiBawah extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavigasiBawah({super.key, this.currentIndex = 0, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.withValues(alpha: 0.1), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_filled, Icons.home_outlined),
            _buildNavItem(
              1,
              Icons.account_balance_wallet,
              Icons.account_balance_wallet_outlined,
            ),
            _buildNavItem(2, Icons.bar_chart, Icons.bar_chart_outlined),
            _buildNavItem(3, Icons.person, Icons.person_outline),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon) {
    final isSelected = currentIndex == index;
    return IconButton(
      onPressed: () => onTap(index),
      icon: Icon(
        isSelected ? activeIcon : inactiveIcon,
        color: isSelected
            ? const Color(0xFF1F2937)
            : Colors.grey, // Dark color for active, grey for inactive
        size: 28,
      ),
    );
  }
}
