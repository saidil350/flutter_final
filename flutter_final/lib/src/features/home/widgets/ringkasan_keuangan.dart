import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RingkasanKeuangan extends StatelessWidget {
  final double income;
  final double expense;

  const RingkasanKeuangan({
    super.key,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

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
              amount: _formatCurrency(income),
              icon: Icons.arrow_downward,
              color: const Color(0xFF27AE60),
              isIncome: true,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.white24),
          Expanded(
            child: _buildSummaryItem(
              title: 'Pengeluaran',
              amount: _formatCurrency(expense),
              icon: Icons.arrow_upward,
              color: const Color(0xFFEB5757),
              isIncome: false,
            ),
          ),
        ],
      ),
    );
  }

  // Format currency, showing millions with two decimal digits
  // Format currency:
  // - >= 1 juta => show in Juta with two decimal digits (e.g., 12.35 Juta)
  // - >= 1 ribu => show in Ribu without decimal (e.g., 500 Ribu)
  // - else => normal Rupiah format
  // Format currency:
  // - >= 1 juta  → show in Juta; if the value is a whole number of juta, omit decimal digits
  // - >= 1 ribu → show in Ribu without decimal
  // - else      → normal Rupiah format
  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      double result = amount / 1000000;
      // If result is an integer (e.g., 10.0), show without decimal
      String resultStr = (result.truncateToDouble() == result)
          ? result.toStringAsFixed(0)
          : result.toStringAsFixed(2);
      return 'Rp $resultStr Juta';
    } else if (amount >= 1000) {
      double result = amount / 1000;
      // No decimal needed for ribu, show as integer
      String resultStr = result.toStringAsFixed(0);
      return 'Rp $resultStr Ribu';
    }
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
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
        Expanded(
          child: Column(
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
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
