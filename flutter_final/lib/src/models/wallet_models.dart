import 'package:flutter/material.dart';

class SavingItem {
  final String id;
  final String title;
  final double currentAmount;
  final double targetAmount;
  final Color color;

  SavingItem({
    required this.id,
    required this.title,
    required this.currentAmount,
    required this.targetAmount,
    required this.color,
  });

  double get progress => (currentAmount / targetAmount).clamp(0.0, 1.0);
  String get targetString => 'Rp ${targetAmount.toStringAsFixed(0)}';

  factory SavingItem.fromMap(Map<String, dynamic> map) {
    return SavingItem(
      id: map['id'],
      title: map['title'],
      currentAmount: (map['current_amount'] as num).toDouble(),
      targetAmount: (map['target_amount'] as num).toDouble(),
      color: Color(int.parse(map['color_hex'].toString())),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'current_amount': currentAmount,
      'target_amount': targetAmount,
      // ignore: deprecated_member_use
      'color_hex': color.value.toString(),
    };
  }
}

class TransactionItem {
  final String id;
  final String title;
  final String subtitle;
  final String amount;
  final Color color;
  final IconData icon;
  final bool isNegative;
  final DateTime date;
  final String category;

  TransactionItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.color,
    required this.icon,
    required this.isNegative,
    required this.date,
    required this.category,
  });

  factory TransactionItem.fromMap(Map<String, dynamic> map) {
    final isNegative = map['is_negative'] as bool;
    return TransactionItem(
      id: map['id'],
      title: map['title'],
      subtitle: map['subtitle'] ?? '',
      amount: 'Rp ${(map['amount'] as num).toString()}',
      // Logic warna: Merah jika pengeluaran, Hijau jika pemasukan
      color: isNegative ? const Color(0xFFEB5757) : const Color(0xFF27AE60),
      // Logic icon sederhana berdasarkan kategori
      icon: _getIconByCategory(map['category']),
      isNegative: isNegative,
      date: DateTime.parse(map['date']).toLocal(),
      category: map['category'] ?? 'Lainnya',
    );
  }

  static IconData _getIconByCategory(String? category) {
    switch (category) {
      case 'Langganan':
        return Icons.subscriptions_outlined;
      case 'Belanja':
        return Icons.shopping_bag_outlined;
      case 'Pendapatan':
        return Icons.attach_money;
      case 'Makan':
        return Icons.restaurant;
      case 'Transport':
        return Icons.directions_car;
      default:
        return Icons.receipt_long;
    }
  }

  // Getter untuk mendapatkan deskripsi tanggal yang user-friendly
  String get dateDescription {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);

    final difference = today.difference(transactionDate).inDays;

    // Helper untuk format waktu (HH:mm)
    String formatTime(DateTime dt) {
      final hour = dt.hour.toString().padLeft(2, '0');
      final minute = dt.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    if (transactionDate == today) {
      return 'Hari ini, ${formatTime(date)}';
    } else if (transactionDate == yesterday) {
      return 'Kemarin, ${formatTime(date)}';
    } else if (difference < 7) {
      return '$difference hari yang lalu';
    } else if (difference < 30) {
      final weeks = (difference / 7).floor();
      return '$weeks minggu yang lalu';
    } else {
      // Format: 15 Nov 2024
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agt',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    }
  }
}
