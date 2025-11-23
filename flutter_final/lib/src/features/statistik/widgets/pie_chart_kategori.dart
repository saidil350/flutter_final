import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartKategori extends StatelessWidget {
  final Map<String, double> categoryData;

  const PieChartKategori({super.key, required this.categoryData});

  @override
  Widget build(BuildContext context) {
    if (categoryData.isEmpty) {
      return _buildEmptyState();
    }

    final total = categoryData.values.fold(0.0, (sum, value) => sum + value);

    return Container(
      padding: const EdgeInsets.all(24),
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
          const Text(
            'Statistik Keuangan',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3135),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: _buildSections(categoryData, total),
                sectionsSpace: 2,
                centerSpaceRadius: 60,
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildLegend(categoryData, total),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(
    Map<String, double> data,
    double total,
  ) {
    final colors = {
      'Pengeluaran': const Color(0xFFEB5757),
      'Pemasukan': const Color(0xFF27AE60),
      'Tabungan': const Color(0xFFF2C94C),
      'Lainnya': const Color(0xFF9B59B6),
    };

    return data.entries.map((entry) {
      final percentage = (entry.value / total * 100);
      final color = colors[entry.key] ?? const Color(0xFF8B8B8B);

      return PieChartSectionData(
        value: entry.value,
        title: '${percentage.toStringAsFixed(1)}%',
        color: color,
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend(Map<String, double> data, double total) {
    final colors = {
      'Pengeluaran': const Color(0xFFEB5757),
      'Pemasukan': const Color(0xFF27AE60),
      'Tabungan': const Color(0xFFF2C94C),
      'Lainnya': const Color(0xFF9B59B6),
    };

    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: data.entries.map((entry) {
        final color = colors[entry.key] ?? const Color(0xFF8B8B8B);
        final percentage = (entry.value / total * 100).toStringAsFixed(1);

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              '${entry.key} ($percentage%)',
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: Color(0xFF2C3135),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: const Center(
        child: Column(
          children: [
            Icon(Icons.pie_chart_outline, size: 48, color: Color(0xFF8B8B8B)),
            SizedBox(height: 16),
            Text(
              'Belum ada data keuangan',
              style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF8B8B8B)),
            ),
          ],
        ),
      ),
    );
  }
}
