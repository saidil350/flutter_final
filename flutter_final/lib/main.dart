import 'package:flutter/material.dart';
import 'src/features/welcome/screens/welcome_screen.dart';
import 'src/features/home/screens/home_screen.dart';
import 'src/core/supabase_config.dart';
import 'src/services/auth_service.dart';

void main() async {
  // Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseConfig.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fintrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: Colors.deepPurple,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const AuthChecker(),
    );
  }
}

// Widget untuk memeriksa status autentikasi
class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  final _authService = AuthService();
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Tunggu sebentar untuk memastikan Supabase sudah siap
    await Future.delayed(const Duration(milliseconds: 500));

    final user = _authService.currentUser;

    setState(() {
      _isAuthenticated = user != null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Tampilkan splash screen saat memeriksa auth
      return const Scaffold(
        backgroundColor: Color(0xFFF2F2F2),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF377CC8)),
        ),
      );
    }

    // Jika sudah login, langsung ke HomeScreen
    // Jika belum, ke WelcomeScreen
    return _isAuthenticated ? const HomeScreen() : const WelcomeScreen();
  }
}
