import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../widgets/auth_header.dart';

class DaftarScreen extends StatelessWidget {
  const DaftarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan ukuran desain referensi
    const double designWidth = 375.0;
    const double designHeight = 812.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          alignment: Alignment.center,
          child: SizedBox(
            width: designWidth,
            height: designHeight,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // --- Header Section (Logo) ---
                  // Skala diperkecil (0.8)
                  Center(
                    child: SizedBox(
                      width: 311 * 0.8,
                      height: 324 * 0.8,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        child: AuthHeader(),
                      ),
                    ),
                  ),

                  // --- Title Header ---
                  const Text(
                    'Daftar',
                    style: TextStyle(
                      color: Color(0xFF242424),
                      fontSize: 28,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- Form Section ---
                  Container(
                    width: 315,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 30,
                    ),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFEAEAEA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildTextField(hint: "Enter your Email"),
                        const SizedBox(height: 20),
                        _buildTextField(
                          hint: "Enter Password",
                          isObscure: true,
                        ),
                        const SizedBox(height: 30),

                        // Daftar Button
                        GestureDetector(
                          onTap: () {
                            // Implementasi register
                          },
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            decoration: ShapeDecoration(
                              color: const Color(0xFF377CC8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Daftar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Login Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "sudah punya akun? ",
                              style: TextStyle(
                                color: Color(0xFF242424),
                                fontSize: 13,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  color: Color(0xFF377CC8),
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String hint, bool isObscure = false}) {
    return Container(
      height: 50,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      child: TextField(
        obscureText: isObscure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.black.withValues(alpha: 0.8),
            fontSize: 13,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
      ),
    );
  }
}
