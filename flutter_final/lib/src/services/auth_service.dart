import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_config.dart';

class AuthService {
  final _auth = SupabaseConfig.auth;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream untuk listen perubahan auth state
  Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;

  // Register dengan email dan password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _auth.signUp(email: email, password: password);
  }

  // Login dengan email dan password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithPassword(email: email, password: password);
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Reset password request
  Future<void> resetPassword(String email) async {
    await _auth.resetPasswordForEmail(email);
  }

  // Update password
  Future<UserResponse> updatePassword(String newPassword) async {
    return await _auth.updateUser(UserAttributes(password: newPassword));
  }
}
