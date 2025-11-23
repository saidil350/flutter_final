import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../widgets/wallet_header.dart';
import '../widgets/add_card_widget.dart';
import '../../home/widgets/kartu_tabungan.dart';
import '../../home/widgets/transaksi_terbaru.dart';
import '../../../services/wallet_service.dart';
import '../../../models/wallet_models.dart';
import '../../../core/utils/currency_formatter.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final walletService = WalletService();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WalletHeader(),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => _showAddDialog(context),
            child: const AddCardWidget(),
          ),
          const SizedBox(height: 24),
          ValueListenableBuilder<List<TransactionItem>>(
            valueListenable: walletService.transactionsNotifier,
            builder: (context, transactions, _) {
              return TransaksiTerbaru(
                enableManagement: true,
                items: transactions,
                onEdit: (item) => _showEditTransactionDialog(context, item),
                onDelete: (id) => _showDeleteConfirmation(context, () {
                  walletService.deleteTransaction(id);
                }),
              );
            },
          ),
          const SizedBox(height: 24),
          ValueListenableBuilder<List<SavingItem>>(
            valueListenable: walletService.savingsNotifier,
            builder: (context, savings, _) {
              return KartuTabungan(
                enableManagement: true,
                items: savings,
                onAddSaldo: (item) => _showAddSaldoDialog(context, item),
                onDelete: (id) => _showDeleteConfirmation(context, () {
                  walletService.deleteSaving(id);
                }),
              );
            },
          ),
          const SizedBox(height: 24), // Bottom padding
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Tambah Data',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3135),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF377CC8).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.savings, color: Color(0xFF377CC8)),
              ),
              title: const Text(
                'Tambah Tabungan',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2C3135),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showAddSavingDialog(context);
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF27AE60).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.receipt_long, color: Color(0xFF27AE60)),
              ),
              title: const Text(
                'Tambah Transaksi',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2C3135),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showAddTransactionDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Konfirmasi Hapus',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3135),
          ),
        ),
        content: const Text(
          'Apakah Anda yakin ingin menghapus item ini?',
          style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF8B8B8B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF8B8B8B)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEB5757),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCongratulationsDialog(BuildContext context, SavingItem item) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Celebration
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.celebration, size: 64, color: item.color),
            ),
            const SizedBox(height: 24),
            // Title
            const Text(
              '🎉 Selamat! 🎉',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2C3135),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Message
            Text(
              'Target tabungan "${item.title}" telah tercapai!',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Color(0xFF8B8B8B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Amount
            Text(
              NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp ',
                decimalDigits: 0,
              ).format(item.targetAmount),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: item.color,
              ),
            ),
            const SizedBox(height: 24),
            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: item.color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Tutup',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Dialogs for Savings ---

  void _showAddSavingDialog(BuildContext context) {
    final titleController = TextEditingController();
    final targetController = TextEditingController();
    final currentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => _buildStyledDialog(
        context: context,
        title: 'Tambah Tabungan',
        children: [
          _buildStyledTextField(
            controller: titleController,
            label: 'Nama Tabungan',
          ),
          const SizedBox(height: 16),
          _buildStyledTextField(
            controller: targetController,
            label: 'Target (Rp)',
            isNumber: true,
            formatters: [NumericTextFormatter()],
          ),
          const SizedBox(height: 16),
          _buildStyledTextField(
            controller: currentController,
            label: 'Terkumpul Saat Ini (Rp)',
            isNumber: true,
            formatters: [NumericTextFormatter()],
          ),
        ],
        onSave: () {
          if (titleController.text.isNotEmpty &&
              targetController.text.isNotEmpty) {
            final targetClean = targetController.text.replaceAll(
              RegExp(r'[^0-9]'),
              '',
            );
            final currentClean = currentController.text.replaceAll(
              RegExp(r'[^0-9]'),
              '',
            );

            final target = double.tryParse(targetClean) ?? 0.0;
            final current = double.tryParse(currentClean) ?? 0.0;

            WalletService().addSaving(
              SavingItem(
                id: DateTime.now().toString(),
                title: titleController.text,
                currentAmount: current,
                targetAmount: target,
                color: const Color(0xFF377CC8), // Default Blue
              ),
            );
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  void _showAddSaldoDialog(BuildContext context, SavingItem item) {
    final amountController = TextEditingController();
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    // Hitung sisa yang dibutuhkan untuk mencapai target
    final sisaTarget = item.targetAmount - item.currentAmount;

    showDialog(
      context: context,
      builder: (context) => _buildStyledDialog(
        context: context,
        title: 'Tambah Saldo - ${item.title}',
        confirmButtonColor: const Color(0xFF27AE60), // Green for adding money
        children: [
          // Info tabungan saat ini
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terkumpul: ${formatter.format(item.currentAmount)}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2C3135),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Target: ${item.targetString}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Color(0xFF8B8B8B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sisa yang dibutuhkan: ${formatter.format(sisaTarget)}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: item.color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildStyledTextField(
            controller: amountController,
            label: 'Jumlah yang Ditabung (Rp)',
            isNumber: true,
            formatters: [NumericTextFormatter()],
          ),
        ],
        onSave: () {
          if (amountController.text.isNotEmpty) {
            final amountClean = amountController.text.replaceAll(
              RegExp(r'[^0-9]'),
              '',
            );
            final amount = double.tryParse(amountClean) ?? 0.0;

            if (amount > 0) {
              // Validasi: Cek apakah melebihi target
              if (amount > sisaTarget) {
                // Tampilkan pesan error
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Jumlah melebihi target! Maksimal yang bisa ditabung: ${formatter.format(sisaTarget)}',
                      style: const TextStyle(fontFamily: 'Poppins'),
                    ),
                    backgroundColor: const Color(0xFFEB5757),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
                return;
              }

              // Update tabungan
              WalletService().updateSaving(
                SavingItem(
                  id: item.id,
                  title: item.title,
                  currentAmount: item.currentAmount + amount,
                  targetAmount: item.targetAmount,
                  color: item.color,
                ),
              );

              // Tambah transaksi
              WalletService().addTransaction(
                TransactionItem(
                  id: DateTime.now().toString(),
                  title: 'Nabung: ${item.title}',
                  subtitle: 'Tabungan',
                  amount: formatter.format(amount),
                  color: item.color,
                  icon: Icons.savings,
                  isNegative: true,
                  date: DateTime.now(),
                  category: 'Tabungan',
                ),
              );

              Navigator.pop(context);

              // Cek jika target tercapai
              if (item.currentAmount + amount >= item.targetAmount) {
                _showCongratulationsDialog(context, item);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Saldo berhasil ditambahkan!',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                    backgroundColor: const Color(0xFF27AE60),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
            }
          }
        },
      ),
    );
  }

  // --- Dialogs for Transactions ---

  void _showAddTransactionDialog(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String tipeTransaksi = 'Pemasukan'; // Default Pemasukan

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => _buildStyledDialog(
          context: context,
          title: 'Tambah Transaksi',
          confirmButtonColor: tipeTransaksi == 'Pemasukan'
              ? const Color(0xFF27AE60)
              : const Color(0xFFEB5757),
          children: [
            _buildStyledTextField(
              controller: titleController,
              label: 'Nama Transaksi',
            ),
            const SizedBox(height: 16),
            _buildStyledTextField(
              controller: amountController,
              label: 'Jumlah (Rp)',
              isNumber: true,
              formatters: [NumericTextFormatter()],
            ),
            const SizedBox(height: 16),
            // Radio Button untuk Tipe Transaksi
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tipe Transaksi',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2C3135),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text(
                          'Pemasukan',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Color(0xFF2C3135),
                          ),
                        ),
                        value: 'Pemasukan',
                        groupValue: tipeTransaksi,
                        activeColor: const Color(0xFF27AE60),
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setState(() {
                            tipeTransaksi = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text(
                          'Pengeluaran',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Color(0xFF2C3135),
                          ),
                        ),
                        value: 'Pengeluaran',
                        groupValue: tipeTransaksi,
                        activeColor: const Color(0xFFEB5757),
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setState(() {
                            tipeTransaksi = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
          onSave: () {
            if (titleController.text.isNotEmpty &&
                amountController.text.isNotEmpty) {
              final amountClean = amountController.text.replaceAll(
                RegExp(r'[^0-9]'),
                '',
              );
              final amount = double.tryParse(amountClean) ?? 0.0;
              final formatter = NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp ',
                decimalDigits: 0,
              );

              // Tentukan warna dan isNegative berdasarkan tipe
              final isPemasukan = tipeTransaksi == 'Pemasukan';
              final color = isPemasukan
                  ? const Color(0xFF27AE60) // Hijau untuk Pemasukan
                  : const Color(0xFFEB5757); // Merah untuk Pengeluaran

              WalletService().addTransaction(
                TransactionItem(
                  id: DateTime.now().toString(),
                  title: titleController.text,
                  subtitle: tipeTransaksi,
                  amount: formatter.format(amount),
                  color: color,
                  icon: Icons.payment,
                  isNegative: !isPemasukan, // true jika Pengeluaran
                  date: DateTime.now(),
                  category: tipeTransaksi, // Kategori sesuai tipe transaksi
                ),
              );
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  void _showEditTransactionDialog(BuildContext context, TransactionItem item) {
    final titleController = TextEditingController(text: item.title);
    final amountClean = item.amount.replaceAll(RegExp(r'[^0-9]'), '');
    final amountVal = double.tryParse(amountClean) ?? 0.0;
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final amountController = TextEditingController(
      text: formatter.format(amountVal),
    );

    // Inisialisasi tipe berdasarkan isNegative
    String tipeTransaksi = item.isNegative ? 'Pengeluaran' : 'Pemasukan';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => _buildStyledDialog(
          context: context,
          title: 'Edit Transaksi',
          confirmButtonColor: tipeTransaksi == 'Pemasukan'
              ? const Color(0xFF27AE60)
              : const Color(0xFFEB5757),
          children: [
            _buildStyledTextField(
              controller: titleController,
              label: 'Nama Transaksi',
            ),
            const SizedBox(height: 16),
            _buildStyledTextField(
              controller: amountController,
              label: 'Jumlah (Rp)',
              isNumber: true,
              formatters: [NumericTextFormatter()],
            ),
            const SizedBox(height: 16),
            // Radio Button untuk Tipe Transaksi
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tipe Transaksi',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2C3135),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text(
                          'Pemasukan',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Color(0xFF2C3135),
                          ),
                        ),
                        value: 'Pemasukan',
                        groupValue: tipeTransaksi,
                        activeColor: const Color(0xFF27AE60),
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setState(() {
                            tipeTransaksi = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text(
                          'Pengeluaran',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Color(0xFF2C3135),
                          ),
                        ),
                        value: 'Pengeluaran',
                        groupValue: tipeTransaksi,
                        activeColor: const Color(0xFFEB5757),
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setState(() {
                            tipeTransaksi = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
          onSave: () {
            if (titleController.text.isNotEmpty &&
                amountController.text.isNotEmpty) {
              final amountClean = amountController.text.replaceAll(
                RegExp(r'[^0-9]'),
                '',
              );
              final amount = double.tryParse(amountClean) ?? 0.0;

              // Tentukan warna dan isNegative berdasarkan tipe
              final isPemasukan = tipeTransaksi == 'Pemasukan';
              final color = isPemasukan
                  ? const Color(0xFF27AE60) // Hijau untuk Pemasukan
                  : const Color(0xFFEB5757); // Merah untuk Pengeluaran

              WalletService().updateTransaction(
                TransactionItem(
                  id: item.id,
                  title: titleController.text,
                  subtitle: tipeTransaksi,
                  amount: formatter.format(amount),
                  color: color,
                  icon: Icons.payment,
                  isNegative: !isPemasukan, // true jika Pengeluaran
                  date: item.date, // Pertahankan tanggal asli saat edit
                  category: tipeTransaksi, // Update kategori sesuai tipe
                ),
              );
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildStyledDialog({
    required BuildContext context,
    required String title,
    required List<Widget> children,
    required VoidCallback onSave,
    Color? confirmButtonColor,
    String confirmText = 'Simpan',
  }) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: Color(0xFF2C3135),
        ),
      ),
      content: Column(mainAxisSize: MainAxisSize.min, children: children),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Batal',
            style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF8B8B8B)),
          ),
        ),
        ElevatedButton(
          onPressed: onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmButtonColor ?? const Color(0xFF377CC8),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(
            confirmText,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String label,
    bool isNumber = false,
    List<TextInputFormatter>? formatters,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: formatters,
      style: const TextStyle(fontFamily: 'Poppins', color: Color(0xFF2C3135)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          color: Color(0xFF8B8B8B),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF377CC8), width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
