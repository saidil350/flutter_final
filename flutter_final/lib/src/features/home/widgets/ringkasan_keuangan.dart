import 'package:flutter/material.dart';

class RingkasanKeuangan extends StatelessWidget {
  const RingkasanKeuangan({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF222222), // Dark background
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryItem(
              title: 'Pemasukan',
              amount: 'Rp 20.000.000', // Updated to match design approx
              icon: Icons.arrow_downward,
              color: const Color(0xFF27AE60),
              isIncome: true,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.white24),
          Expanded(
            child: _buildSummaryItem(
              title: 'Pengeluaran',
              amount: 'Rp 17.000.000', // Updated to match design approx
              icon: Icons.arrow_upward,
              color: const Color(0xFFEB5757),
              isIncome: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String title,
    required String amount,
    required IconData icon,
    required Color color,
    required bool isIncome,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                color: Color(0xFF8B8B8B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              amount,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
