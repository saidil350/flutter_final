import 'package:flutter/material.dart';
import '../../../services/wallet_service.dart';
import '../../../models/wallet_models.dart';
import '../widgets/pie_chart_kategori.dart';
import '../widgets/bar_chart_perbandingan.dart';
import '../widgets/candlestick_chart_tren.dart';

class StatistikScreen extends StatefulWidget {
  const StatistikScreen({super.key});

  @override
  State<StatistikScreen> createState() => _StatistikScreenState();
}

class _StatistikScreenState extends State<StatistikScreen> {
  final _walletService = WalletService();
  String _selectedPeriod = 'Semua'; // Default filter: Semua

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Statistik',
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2C3135),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Visualisasi keuangan Anda',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF8B8B8B),
                ),
              ),
              const SizedBox(height: 24),

              // Filter Periode
              _buildFilterPeriode(),
              const SizedBox(height: 24),

              // Summary Cards
              ValueListenableBuilder<List<TransactionItem>>(
                valueListenable: _walletService.transactionsNotifier,
                builder: (context, transactions, _) {
                  return _buildSummaryCards();
                },
              ),
              const SizedBox(height: 32),

              // Pie Chart - Kategori Pengeluaran
              ValueListenableBuilder<List<TransactionItem>>(
                valueListenable: _walletService.transactionsNotifier,
                builder: (context, transactions, _) {
                  final categoryData = _walletService.getCategoryExpenses();
                  return PieChartKategori(categoryData: categoryData);
                },
              ),
              const SizedBox(height: 24),

              // Bar Chart - Pemasukan vs Pengeluaran
              ValueListenableBuilder<List<TransactionItem>>(
                valueListenable: _walletService.transactionsNotifier,
                builder: (context, transactions, _) {
                  final dailyData = _walletService.getDailyIncomeExpense();
                  return BarChartPerbandingan(dailyData: dailyData);
                },
              ),
              const SizedBox(height: 24),

              // Candlestick Chart - Tren Saldo
              ValueListenableBuilder<List<TransactionItem>>(
                valueListenable: _walletService.transactionsNotifier,
                builder: (context, transactions, _) {
                  final candlestickData = _walletService.getCandlestickData();
                  return CandlestickChartTren(candlestickData: candlestickData);
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterPeriode() {
    final periods = ['Hari Ini', 'Minggu Ini', 'Bulan Ini', 'Semua'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: periods.map((period) {
          final isSelected = _selectedPeriod == period;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(period),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedPeriod = period;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFF377CC8),
              labelStyle: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF2C3135),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF377CC8)
                      : const Color(0xFFE5E7EB),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Pemasukan',
            _walletService.totalIncome,
            const Color(0xFF27AE60),
            Icons.arrow_downward,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            'Pengeluaran',
            _walletService.totalExpense,
            const Color(0xFFEB5757),
            Icons.arrow_upward,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String label,
    double amount,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Color(0xFF8B8B8B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              color: Color(0xFF2C3135),
            ),
          ),
        ],
      ),
    );
  }
}
