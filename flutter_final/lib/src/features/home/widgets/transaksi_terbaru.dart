import 'package:flutter/material.dart';

class TransaksiTerbaru extends StatelessWidget {
  const TransaksiTerbaru({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Transaksi Terakhir',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Color(0xFF242424),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Lihat Semua',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF377CC8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildTransactionItem(
              title: 'Adobe Illustrator',
              subtitle: 'Subscription fee',
              amount: '-\$32.00',
              color: const Color(0xFFF2C94C), // Yellow
              icon: Icons.laptop_mac,
              isNegative: true,
            ),
            const SizedBox(height: 16),
            _buildTransactionItem(
              title: 'Dribbble',
              subtitle: 'Subscription fee',
              amount: '-\$15.00',
              color: const Color(0xFFF2C94C), // Yellow
              icon: Icons.laptop_mac,
              isNegative: true,
            ),
            const SizedBox(height: 16),
            _buildTransactionItem(
              title: 'Sony Camera',
              subtitle: 'Shopping fee',
              amount: '-\$200.00',
              color: const Color(0xFFEB869A), // Pink
              icon: Icons.shopping_bag_outlined,
              isNegative: true,
            ),
            const SizedBox(height: 16),
            _buildTransactionItem(
              title: 'Paypal',
              subtitle: 'Salary',
              amount: '+\$32.00',
              color: const Color(0xFF27AE60), // Green
              icon: Icons.credit_card,
              isNegative: false,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionItem({
    required String title,
    required String subtitle,
    required String amount,
    required Color color,
    required IconData icon,
    required bool isNegative,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF242424),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    color: Color(0xFF8B8B8B),
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: isNegative
                  ? const Color(0xFFEB5757)
                  : const Color(0xFF27AE60),
            ),
          ),
        ],
      ),
    );
  }
}
