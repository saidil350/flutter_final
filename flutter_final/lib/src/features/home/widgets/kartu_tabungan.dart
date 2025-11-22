import 'package:flutter/material.dart';

class KartuTabungan extends StatelessWidget {
  const KartuTabungan({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tabungan',
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
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildSavingItem(
                title: 'Iphone 13 Mini',
                target: 'Rp 10.500.000',
                progress: 0.4,
                color: const Color(0xFFE55039), // Red/Orange
              ),
              const SizedBox(width: 16),
              _buildSavingItem(
                title: 'Macbook Pro M1',
                target: 'Rp 22.500.000',
                progress: 0.6,
                color: const Color(0xFFEB869A), // Pink
              ),
              const SizedBox(width: 16),
              _buildSavingItem(
                title: 'Mobil Impian',
                target: 'Rp 250.000.000',
                progress: 0.2,
                color: const Color(0xFFF2C94C), // Yellow
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSavingItem({
    required String title,
    required String target,
    required double progress,
    required Color color,
  }) {
    return Container(
      width: 200, // Increased width further to prevent overflow
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF242424),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8), // Add spacing between text and icon
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: Color(0xFF242424),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              target,
              style: const TextStyle(
                fontSize: 18, // Slightly smaller font
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Color(0xFF242424),
              ),
            ),
          ),
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
