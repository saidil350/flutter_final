import 'package:flutter/material.dart';
import '../widgets/header_beranda.dart';
import '../widgets/kartu_saldo.dart';
import '../widgets/ringkasan_keuangan.dart';
import '../widgets/kartu_pendapatan.dart';
import '../widgets/kartu_tabungan.dart';
import '../widgets/transaksi_terbaru.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              const HeaderBeranda(),
              const SizedBox(height: 24),
              const KartuSaldo(),
              const SizedBox(height: 24),
              const RingkasanKeuangan(),
              const SizedBox(height: 24),
              const KartuPendapatan(),
              const SizedBox(height: 24),
              const KartuTabungan(),
              const SizedBox(height: 24),
              const TransaksiTerbaru(),
              const SizedBox(height: 24), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
