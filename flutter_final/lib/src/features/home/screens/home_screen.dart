import 'package:flutter/material.dart';
import '../widgets/header_beranda.dart';
import '../widgets/kartu_saldo.dart';
import '../widgets/ringkasan_keuangan.dart';
import '../widgets/kartu_tabungan.dart';
import '../widgets/transaksi_terbaru.dart';
import '../widgets/navigasi_bawah.dart';
import '../../wallet/screens/wallet_screen.dart';
import '../../statistik/screens/statistik_screen.dart';
import '../../profil/screens/profil_screen.dart';
import '../../../services/wallet_service.dart';
import '../../../models/wallet_models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final _walletService = WalletService();

  @override
  void initState() {
    super.initState();
    // Load data saat screen pertama kali dibuka
    _walletService.loadData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            // Tab 0: Home
            SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderBeranda(),
                  const SizedBox(height: 24),
                  // KartuSaldo dengan ValueListenableBuilder untuk transactions
                  ValueListenableBuilder<List<TransactionItem>>(
                    valueListenable: _walletService.transactionsNotifier,
                    builder: (context, transactions, _) {
                      return KartuSaldo(balance: _walletService.totalBalance);
                    },
                  ),
                  const SizedBox(height: 24),
                  // RingkasanKeuangan dengan ValueListenableBuilder
                  ValueListenableBuilder<List<TransactionItem>>(
                    valueListenable: _walletService.transactionsNotifier,
                    builder: (context, transactions, _) {
                      return RingkasanKeuangan(
                        income: _walletService.totalIncome,
                        expense: _walletService.totalExpense,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  ValueListenableBuilder<List<SavingItem>>(
                    valueListenable: _walletService.savingsNotifier,
                    builder: (context, savings, _) {
                      return KartuTabungan(items: savings);
                    },
                  ),
                  const SizedBox(height: 24),
                  ValueListenableBuilder<List<TransactionItem>>(
                    valueListenable: _walletService.transactionsNotifier,
                    builder: (context, transactions, _) {
                      return TransaksiTerbaru(items: transactions);
                    },
                  ),
                  const SizedBox(height: 24), // Bottom padding
                ],
              ),
            ),
            // Tab 1: Wallet
            const WalletScreen(),
            // Tab 2: Statistik
            const StatistikScreen(),
            // Tab 3: Profil
            const ProfilScreen(),
          ],
        ),
      ),
      bottomNavigationBar: NavigasiBawah(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
