import 'package:flutter/material.dart';
import '../../../services/wallet_service.dart';

class CandlestickChartTren extends StatefulWidget {
  final List<CandlestickData> candlestickData;

  const CandlestickChartTren({super.key, required this.candlestickData});

  @override
  State<CandlestickChartTren> createState() => _CandlestickChartTrenState();
}

class _CandlestickChartTrenState extends State<CandlestickChartTren> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    // Otomatis pilih data terbaru (terakhir) saat inisialisasi jika data ada
    if (widget.candlestickData.isNotEmpty) {
      _selectedIndex = widget.candlestickData.length - 1;
    }
  }

  @override
  void didUpdateWidget(CandlestickChartTren oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Jika data baru masuk (dari kosong ke ada), pilih yang terbaru
    if (oldWidget.candlestickData.isEmpty &&
        widget.candlestickData.isNotEmpty) {
      _selectedIndex = widget.candlestickData.length - 1;
    }
    // Jaga agar index tidak out of bounds jika data berubah
    if (_selectedIndex != null &&
        _selectedIndex! >= widget.candlestickData.length) {
      _selectedIndex = widget.candlestickData.isNotEmpty
          ? widget.candlestickData.length - 1
          : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.candlestickData.isEmpty) {
      return _buildEmptyState();
    }

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
          // Header / Info Box
          _buildHeader(),
          const SizedBox(height: 24),
          // Chart Area
          SizedBox(
            height: 250,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return _buildCandlestickChart(constraints);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (_selectedIndex != null &&
        _selectedIndex! < widget.candlestickData.length) {
      final data = widget.candlestickData[_selectedIndex!];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.date.replaceAll('\n', ' '), // Gabungkan hari dan tanggal
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3135),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem('Open', data.open),
              _buildInfoItem('High', data.high),
              _buildInfoItem('Low', data.low),
              _buildInfoItem('Close', data.close),
            ],
          ),
        ],
      );
    }

    // Default Header
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Tren Saldo',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3135),
          ),
        ),
        // Legend
        Row(
          children: [
            _buildLegendItem('Naik', const Color(0xFF27AE60)),
            const SizedBox(width: 12),
            _buildLegendItem('Turun', const Color(0xFFEB5757)),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontFamily: 'Poppins',
            color: Color(0xFF8B8B8B),
          ),
        ),
        Text(
          _formatCurrencySimple(value),
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3135),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontFamily: 'Poppins',
            color: Color(0xFF8B8B8B),
          ),
        ),
      ],
    );
  }

  Widget _buildCandlestickChart(BoxConstraints constraints) {
    final maxValue = _getMaxValue();
    final minValue = _getMinValue();
    final range = maxValue - minValue;
    final chartHeight = constraints.maxHeight - 40; // Reserve space for labels
    final chartWidth = constraints.maxWidth - 60; // Reserve space for Y-axis
    final candleWidth = chartWidth / (widget.candlestickData.length * 2);

    return Stack(
      children: [
        // Grid lines
        Positioned(
          left: 50,
          top: 0,
          right: 0,
          bottom: 30,
          child: _buildGridLines(chartHeight),
        ),
        // Y-axis labels
        Positioned(
          left: 0,
          top: 0,
          bottom: 30,
          child: _buildYAxisLabels(chartHeight, minValue, maxValue),
        ),
        // Candlesticks
        Positioned(
          left: 50,
          top: 0,
          right: 0,
          bottom: 30,
          child: GestureDetector(
            onTapUp: (details) {
              // Hitung index berdasarkan posisi tap
              final x = details.localPosition.dx;
              final totalWidth = constraints.maxWidth - 50; // Lebar area chart
              final itemWidth = totalWidth / widget.candlestickData.length;

              final index = (x / itemWidth).floor();

              if (index >= 0 && index < widget.candlestickData.length) {
                setState(() {
                  _selectedIndex = index;
                });
              }
            },
            child: Container(
              color: Colors.transparent, // Agar bisa detect tap di area kosong
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(
                  widget.candlestickData.length,
                  (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: _buildCandlestick(
                      widget.candlestickData[index],
                      chartHeight,
                      candleWidth,
                      minValue,
                      range,
                      isSelected: _selectedIndex == index,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // X-axis labels
        Positioned(left: 50, right: 0, bottom: 0, child: _buildXAxisLabels()),
      ],
    );
  }

  Widget _buildGridLines(double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        6,
        (index) => Container(height: 1, color: const Color(0xFFE5E7EB)),
      ),
    );
  }

  Widget _buildYAxisLabels(double height, double minValue, double maxValue) {
    final step = (maxValue - minValue) / 5;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        final value = maxValue - (step * index);
        return SizedBox(
          width: 55,
          child: Text(
            _formatCurrency(value),
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 9,
              fontFamily: 'Poppins',
              color: Color(0xFF8B8B8B),
            ),
          ),
        );
      }),
    );
  }

  String _formatCurrency(double value) {
    // Untuk jutaan, tampilkan dalam format juta jika terlalu panjang
    if (value >= 1000000) {
      final juta = value / 1000000;
      if (juta >= 10) {
        return '${juta.toStringAsFixed(0)}jt';
      } else {
        return '${juta.toStringAsFixed(1)}jt';
      }
    } else if (value >= 1000) {
      final ribu = value / 1000;
      return '${ribu.toStringAsFixed(0)}rb';
    }

    return value
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  String _formatCurrencySimple(double value) {
    // Format angka lengkap dengan pemisah titik
    return value
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  Widget _buildXAxisLabels() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widget.candlestickData.asMap().entries.map((entry) {
        final index = entry.key;
        final data = entry.value;
        final isSelected = _selectedIndex == index;

        return Text(
          data.date,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9,
            fontFamily: 'Poppins',
            color: isSelected
                ? const Color(0xFF377CC8)
                : const Color(0xFF8B8B8B),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            height: 1.2,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCandlestick(
    CandlestickData data,
    double chartHeight,
    double candleWidth,
    double minValue,
    double range, {
    bool isSelected = false,
  }) {
    final isBullish = data.isBullish;
    final color = isBullish ? const Color(0xFF27AE60) : const Color(0xFFEB5757);

    // Calculate positions (inverted because Y-axis goes from top to bottom)
    final highY = chartHeight * (1 - (data.high - minValue) / range);
    final lowY = chartHeight * (1 - (data.low - minValue) / range);
    final openY = chartHeight * (1 - (data.open - minValue) / range);
    final closeY = chartHeight * (1 - (data.close - minValue) / range);

    final bodyTop = isBullish ? closeY : openY;
    final bodyBottom = isBullish ? openY : closeY;
    final bodyHeight = (bodyBottom - bodyTop).abs().clamp(2.0, double.infinity);

    return Container(
      // Tambahkan background transparan agar area tap lebih luas
      color: Colors.transparent,
      width: candleWidth * 2,
      height: chartHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Selection Indicator (Background highlight)
          if (isSelected)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

          // Wick (high-low line)
          Positioned(
            top: highY,
            child: Container(width: 2, height: lowY - highY, color: color),
          ),
          // Body (open-close rectangle)
          Positioned(
            top: bodyTop,
            child: Container(
              width: candleWidth * 1.5,
              height: bodyHeight,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
                border: isSelected
                    ? Border.all(color: Colors.black12, width: 1)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getMaxValue() {
    if (widget.candlestickData.isEmpty) return 100;
    final max = widget.candlestickData
        .map((e) => e.high)
        .reduce((a, b) => a > b ? a : b);
    return max * 1.1; // Add 10% padding
  }

  double _getMinValue() {
    if (widget.candlestickData.isEmpty) return 0;
    final min = widget.candlestickData
        .map((e) => e.low)
        .reduce((a, b) => a < b ? a : b);
    return min * 0.9; // Subtract 10% padding
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
            Icon(Icons.candlestick_chart, size: 48, color: Color(0xFF8B8B8B)),
            SizedBox(height: 16),
            Text(
              'Belum ada data saldo',
              style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF8B8B8B)),
            ),
          ],
        ),
      ),
    );
  }
}
