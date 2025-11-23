import 'package:flutter/material.dart';
import '../../auth/screens/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan ukuran desain referensi (iPhone X/11/12/13 mini width)
    const double designWidth = 375.0;
    const double designHeight = 812.0; // Standar tinggi desain mobile

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          alignment: Alignment.center,
          child: SizedBox(
            width: designWidth,
            height: designHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // --- Background Pattern (Logo) ---
                // Posisi sesuai snippet: top 138, left 32
                Positioned(
                  left: 32,
                  top: 138,
                  child: SizedBox(
                    width: 311,
                    height: 311,
                    child: Image.asset(
                      'assets/images/onboarding_pattern.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // --- Teks Judul & Deskripsi ---
                // Posisi sesuai snippet: top 474, left 46
                Positioned(
                  left: 46,
                  top: 474,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(
                        width: 311, // Lebar teks dibatasi
                        child: Text(
                          'Saidil Mursal Fintrack Management',
                          style: TextStyle(
                            color: Color(0xFF242424),
                            fontSize: 32,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w600,
                            height: 1.25,
                          ),
                        ),
                      ),
                      SizedBox(height: 16), // Jarak antar teks
                      SizedBox(
                        width: 284,
                        child: Text(
                          'Fintrack adalah aplikasi mobile yang dapat membantu kamu mengelola keuangan dengan cara yang sederhana.',
                          style: TextStyle(
                            color: Color(0xFF242424),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // --- Tombol Panah ---
                // Posisi sesuai snippet: top 733, left 32
                Positioned(
                  left: 32,
                  top: 733,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width:
                          311, // Lebar tombol disesuaikan (full width container)
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_forward,
                          size: 28,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
