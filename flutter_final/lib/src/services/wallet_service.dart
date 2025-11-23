import 'package:flutter/material.dart';

import '../core/supabase_config.dart';
import '../models/wallet_models.dart';

class WalletService {
  static final WalletService _instance = WalletService._internal();
  factory WalletService() => _instance;
  WalletService._internal();

  final _supabase = SupabaseConfig.client;

  // Notifiers untuk UI updates
  final ValueNotifier<List<SavingItem>> savingsNotifier = ValueNotifier([]);
  final ValueNotifier<List<TransactionItem>> transactionsNotifier =
      ValueNotifier([]);

  // Load data dari Supabase
  Future<void> loadData() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      savingsNotifier.value = [];
      transactionsNotifier.value = [];
      return;
    }

    try {
      // Fetch Savings
      final savingsResponse = await _supabase
          .from('savings')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: true);

      final savingsList = (savingsResponse as List)
          .map((e) => SavingItem.fromMap(e))
          .toList();
      savingsNotifier.value = savingsList;

      // Fetch Transactions
      final transactionsResponse = await _supabase
          .from('transactions')
          .select()
          .eq('user_id', user.id)
          .order('date', ascending: false);

      final transactionsList = (transactionsResponse as List)
          .map((e) => TransactionItem.fromMap(e))
          .toList();
      transactionsNotifier.value = transactionsList;
    } catch (e) {
      debugPrint('Error loading data: $e');
    }
  }

  // Getter: Menghitung total pemasukan dari transaksi positif
  double get totalIncome {
    double total = 0.0;
    for (var transaction in transactionsNotifier.value) {
      if (!transaction.isNegative) {
        total += _parseAmount(transaction.amount);
      }
    }
    return total;
  }

  // Getter: Menghitung total pengeluaran dari transaksi negatif
  double get totalExpense {
    double total = 0.0;
    for (var transaction in transactionsNotifier.value) {
      if (transaction.isNegative) {
        total += _parseAmount(transaction.amount).abs();
      }
    }
    return total;
  }

  // Getter: Menghitung total saldo (pemasukan - pengeluaran)
  double get totalBalance {
    return totalIncome - totalExpense;
  }

  // Helper function untuk parsing amount dari string
  double _parseAmount(String amount) {
    String cleaned = amount
        .replaceAll('Rp', '')
        .replaceAll('\$', '')
        .replaceAll(' ', '')
        .replaceAll('.', '')
        .replaceAll(',', '')
        .replaceAll('+', '')
        .replaceAll('-', '')
        .trim();

    return double.tryParse(cleaned) ?? 0.0;
  }

  // CRUD for Savings
  Future<void> addSaving(SavingItem item) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _supabase.from('savings').insert({
        'user_id': user.id,
        'title': item.title,
        'target_amount': item.targetAmount,
        'current_amount': item.currentAmount,
        // ignore: deprecated_member_use
        'color_hex': item.color.value.toString(),
      });
      await loadData(); // Reload data
    } catch (e) {
      debugPrint('Error adding saving: $e');
    }
  }

  Future<void> updateSaving(SavingItem item) async {
    try {
      await _supabase
          .from('savings')
          .update({
            'title': item.title,
            'target_amount': item.targetAmount,
            'current_amount': item.currentAmount,
            // ignore: deprecated_member_use
            'color_hex': item.color.value.toString(),
          })
          .eq('id', item.id);
      await loadData();
    } catch (e) {
      debugPrint('Error updating saving: $e');
    }
  }

  Future<void> deleteSaving(String id) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    // Cari item sebelum dihapus untuk dicatat di transaksi pembatalan
    final savingToDelete = savingsNotifier.value.firstWhere(
      (e) => e.id == id,
      orElse: () => SavingItem(
        id: '',
        title: '',
        currentAmount: 0,
        targetAmount: 0,
        color: const Color(0xFF377CC8),
      ),
    );

    if (savingToDelete.id.isEmpty) return;

    try {
      // Hapus dari DB
      await _supabase.from('savings').delete().eq('id', id);

      // Jika ada saldo, kembalikan ke dompet sebagai transaksi masuk
      if (savingToDelete.currentAmount > 0) {
        await _supabase.from('transactions').insert({
          'user_id': user.id,
          'title': 'Tabungan Dibatalkan: ${savingToDelete.title}',
          'subtitle': 'Pembatalan Tabungan',
          'amount': savingToDelete.currentAmount,
          'is_negative': false,
          'category': 'Lainnya',
          'date': DateTime.now().toIso8601String(),
        });
      }

      await loadData();
    } catch (e) {
      debugPrint('Error deleting saving: $e');
    }
  }

  // CRUD for Transactions
  Future<void> addTransaction(TransactionItem item) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      // Parse amount string ke double
      final amountVal = _parseAmount(item.amount);

      await _supabase.from('transactions').insert({
        'user_id': user.id,
        'title': item.title,
        'subtitle': item.subtitle,
        'amount': amountVal,
        'is_negative': item.isNegative,
        'category': item.category,
        'date': item.date.toIso8601String(),
      });
      await loadData();
    } catch (e) {
      debugPrint('Error adding transaction: $e');
    }
  }

  Future<void> updateTransaction(TransactionItem item) async {
    try {
      final amountVal = _parseAmount(item.amount);

      await _supabase
          .from('transactions')
          .update({
            'title': item.title,
            'subtitle': item.subtitle,
            'amount': amountVal,
            'is_negative': item.isNegative,
            'category': item.category,
            'date': item.date.toIso8601String(),
          })
          .eq('id', item.id);
      await loadData();
    } catch (e) {
      debugPrint('Error updating transaction: $e');
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _supabase.from('transactions').delete().eq('id', id);
      await loadData();
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
    }
  }

  // Helper methods untuk Statistik

  // Get kategori keuangan (untuk Pie Chart)
  Map<String, double> getCategoryExpenses() {
    final Map<String, double> categoryData = {
      'Pengeluaran': 0.0,
      'Pemasukan': 0.0,
      'Tabungan': 0.0,
    };

    for (var transaction in transactionsNotifier.value) {
      final amount = _parseAmount(transaction.amount);

      // Kelompokkan berdasarkan tipe transaksi
      if (transaction.category == 'Tabungan') {
        categoryData['Tabungan'] = (categoryData['Tabungan'] ?? 0) + amount;
      } else if (transaction.isNegative) {
        categoryData['Pengeluaran'] =
            (categoryData['Pengeluaran'] ?? 0) + amount;
      } else {
        categoryData['Pemasukan'] = (categoryData['Pemasukan'] ?? 0) + amount;
      }
    }

    // Hapus kategori yang nilainya 0
    categoryData.removeWhere((key, value) => value == 0);

    return categoryData;
  }

  // Get data harian untuk Bar Chart (7 hari terakhir)
  Map<String, Map<String, double>> getDailyIncomeExpense() {
    final Map<String, Map<String, double>> dailyData = {};
    final now = DateTime.now();

    // Generate 7 hari terakhir
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = '${date.day}/${date.month}';
      dailyData[dateKey] = {'income': 0.0, 'expense': 0.0};
    }

    // Aggregate transaksi
    for (var transaction in transactionsNotifier.value) {
      final transDate = transaction.date;
      final dateKey = '${transDate.day}/${transDate.month}';

      if (dailyData.containsKey(dateKey)) {
        final amount = _parseAmount(transaction.amount);
        if (transaction.isNegative) {
          dailyData[dateKey]!['expense'] =
              (dailyData[dateKey]!['expense'] ?? 0) + amount;
        } else {
          dailyData[dateKey]!['income'] =
              (dailyData[dateKey]!['income'] ?? 0) + amount;
        }
      }
    }

    return dailyData;
  }

  // Get balance history untuk Line Chart (7 hari terakhir)
  List<MapEntry<String, double>> getBalanceHistory() {
    final List<MapEntry<String, double>> history = [];
    final now = DateTime.now();

    // Generate 7 hari terakhir
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = '${date.day}/${date.month}';

      // Calculate balance up to this date
      double dayBalance = 0;
      for (var transaction in transactionsNotifier.value) {
        if (transaction.date.isBefore(date) ||
            (transaction.date.day == date.day &&
                transaction.date.month == date.month)) {
          final amount = _parseAmount(transaction.amount);
          if (transaction.isNegative) {
            dayBalance -= amount;
          } else {
            dayBalance += amount;
          }
        }
      }

      history.add(MapEntry(dateKey, dayBalance.abs()));
    }

    return history;
  }

  // Get candlestick data untuk Candlestick Chart (7 hari terakhir)
  List<CandlestickData> getCandlestickData() {
    final List<CandlestickData> candlesticks = [];
    final now = DateTime.now();

    // Generate 7 hari terakhir
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayName = _getDayName(date.weekday);
      // Format: Nama Hari (baris 1) + Tanggal (baris 2)
      final dateKey = '$dayName\n${date.day}/${date.month}';

      // Hitung saldo awal hari (sebelum transaksi hari ini)
      double openBalance = 0;
      for (var transaction in transactionsNotifier.value) {
        if (transaction.date.isBefore(date)) {
          final amount = _parseAmount(transaction.amount);
          if (transaction.isNegative) {
            openBalance -= amount;
          } else {
            openBalance += amount;
          }
        }
      }

      // Hitung semua transaksi di hari ini
      final dayTransactions = transactionsNotifier.value
          .where(
            (t) =>
                t.date.day == date.day &&
                t.date.month == date.month &&
                t.date.year == date.year,
          )
          .toList();

      // Sort berdasarkan waktu
      dayTransactions.sort((a, b) => a.date.compareTo(b.date));

      double currentBalance = openBalance;
      double high = openBalance;
      double low = openBalance;

      // Proses setiap transaksi untuk mendapatkan high dan low
      for (var transaction in dayTransactions) {
        final amount = _parseAmount(transaction.amount);
        if (transaction.isNegative) {
          currentBalance -= amount;
        } else {
          currentBalance += amount;
        }

        if (currentBalance > high) high = currentBalance;
        if (currentBalance < low) low = currentBalance;
      }

      final closeBalance = currentBalance;

      // Pastikan nilai tidak negatif
      candlesticks.add(
        CandlestickData(
          date: dateKey,
          open: openBalance.abs(),
          high: high.abs(),
          low: low.abs(),
          close: closeBalance.abs(),
        ),
      );
    }

    return candlesticks;
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Sen';
      case 2:
        return 'Sel';
      case 3:
        return 'Rab';
      case 4:
        return 'Kam';
      case 5:
        return 'Jum';
      case 6:
        return 'Sab';
      case 7:
        return 'Min';
      default:
        return '';
    }
  }
}

// Model untuk data candlestick
class CandlestickData {
  final String date;
  final double open;
  final double high;
  final double low;
  final double close;

  CandlestickData({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  bool get isBullish => close >= open;
}
