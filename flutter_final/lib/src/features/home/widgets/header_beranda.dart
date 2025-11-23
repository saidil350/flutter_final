import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import '../../../services/wallet_service.dart';

class HeaderBeranda extends StatelessWidget {
  const HeaderBeranda({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 0 && hour < 11) {
      return 'Selamat Pagi,';
    } else if (hour >= 11 && hour < 15) {
      return 'Selamat Siang,';
    } else if (hour >= 15 && hour < 18) {
      return 'Selamat Sore,';
    } else {
      return 'Selamat Malam,';
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final walletService = WalletService();
    final user = authService.currentUser;

    // Ambil nama dari metadata atau email
    final String displayName =
        user?.userMetadata?['nama'] ?? user?.email?.split('@')[0] ?? 'User';

    // Dapatkan sapaan berdasarkan waktu
    final String greeting = _getGreeting();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF377CC8), Color(0xFF5B9FE3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Color(0xFF8B8B8B),
                  ),
                ),
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF242424),
                  ),
                ),
              ],
            ),
          ],
        ),
        // Icon Notifikasi dengan Badge
        ValueListenableBuilder(
          valueListenable: walletService.savingsNotifier,
          builder: (context, savings, _) {
            // Hitung jumlah tabungan yang sudah mencapai target (progress >= 100%)
            final completedSavings = savings
                .where((s) => s.progress >= 1.0)
                .length;
            final hasNotification = completedSavings > 0;

            return Stack(
              children: [
                IconButton(
                  onPressed: () {
                    if (hasNotification) {
                      _showNotificationDialog(context, savings);
                    }
                  },
                  icon: Icon(
                    hasNotification
                        ? Icons.notifications_active
                        : Icons.notifications_outlined,
                    color: hasNotification
                        ? const Color(0xFF377CC8)
                        : const Color(0xFF242424),
                    size: 28,
                  ),
                ),
                // Badge notifikasi
                if (hasNotification)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEB5757),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Center(
                        child: Text(
                          completedSavings > 9 ? '9+' : '$completedSavings',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _showNotificationDialog(BuildContext context, List savings) {
    final completedSavings = savings.where((s) => s.progress >= 1.0).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.celebration, color: Color(0xFF27AE60), size: 28),
            const SizedBox(width: 12),
            const Text(
              'Selamat!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tabungan Anda telah mencapai target:',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Color(0xFF8B8B8B),
              ),
            ),
            const SizedBox(height: 16),
            ...completedSavings.map(
              (saving) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: saving.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            saving.title,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            saving.targetString,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Color(0xFF8B8B8B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF27AE60),
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Tutup',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Color(0xFF377CC8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
