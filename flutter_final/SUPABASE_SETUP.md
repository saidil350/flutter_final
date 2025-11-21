# Setup Supabase untuk Flutter Final

## 📋 Langkah-Langkah Setup

### 1. Install Dependencies ✅

Dependencies berikut sudah ditambahkan ke `pubspec.yaml`:

- `supabase_flutter: ^2.6.0` - SDK Supabase untuk Flutter
- `flutter_dotenv: ^5.2.1` - Untuk mengelola environment variables
- `shared_preferences: ^2.3.2` - Untuk menyimpan session user

**Status**: ✅ Sudah dijalankan `flutter pub get`

### 2. Konfigurasi Supabase Project

#### a. Buat Project di Supabase

1. Buka [https://supabase.com](https://supabase.com)
2. Login atau buat akun baru
3. Klik **"New Project"**
4. Isi informasi project:
   - **Name**: flutter_final (atau nama yang Anda inginkan)
   - **Database Password**: Simpan password ini dengan aman
   - **Region**: Pilih region terdekat (misalnya: Southeast Asia)
5. Tunggu hingga project selesai dibuat (~2 menit)

#### b. Dapatkan API Credentials

1. Setelah project dibuat, buka **Settings** (ikon gear di sidebar)
2. Pilih **API** pada menu sebelah kiri
3. Copy kredensial berikut:
   - **Project URL** (dibagian Project API keys)
   - **anon/public key** (dibagian Project API keys)

#### c. Setup Environment Variables

1. Buat file `.env` di root project (sejajar dengan `pubspec.yaml`)
2. Copy isi dari `.env.example` ke `.env`
3. Ganti placeholder dengan kredensial Supabase Anda:

```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

> ⚠️ **PENTING**: Jangan commit file `.env` ke Git! Pastikan `.env` sudah ada di `.gitignore`

### 3. Setup Database Schema

#### a. Jalankan SQL Schema

1. Buka Supabase Dashboard
2. Pilih **SQL Editor** dari sidebar
3. Klik **"New Query"**
4. Copy seluruh isi file `supabase_auth_schema.sql`
5. Paste ke SQL Editor
6. Klik **"Run"** atau tekan `Ctrl + Enter`
7. Pastikan semua query berhasil dijalankan tanpa error

#### b. Verifikasi Database

Setelah menjalankan SQL, periksa apakah tabel-tabel berikut sudah dibuat:

- ✅ `public.profiles` - Menyimpan data user (email, full_name, avatar_url)
- ✅ `public.user_sessions` - Menyimpan history login (opsional)

Cara cek:

1. Buka **Table Editor** di Supabase Dashboard
2. Anda akan melihat tabel `profiles` dan `user_sessions`

### 4. Konfigurasi Email Authentication (Opsional)

#### a. Aktifkan Email Confirmation

1. Buka **Authentication** > **Settings** > **Email Auth**
2. Toggle **"Confirm email"** jika Anda ingin user konfirmasi email sebelum bisa login
3. Customize email templates di **Authentication** > **Email Templates**

#### b. Setup Email Provider (Production)

Supabase secara default menggunakan built-in email service (terbatas). Untuk production, sebaiknya setup SMTP sendiri:

1. **Authentication** > **Settings** > **SMTP Settings**
2. Masukkan SMTP credentials (Gmail, SendGrid, AWS SES, dll)

### 5. Inisialisasi Supabase di Flutter

Buat file `lib/src/core/supabase_config.dart`:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> initialize() async {
    // Load environment variables
    await dotenv.load(fileName: ".env");

    // Initialize Supabase
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
  }

  // Helper untuk akses Supabase client
  static SupabaseClient get client => Supabase.instance.client;

  // Helper untuk akses auth
  static GoTrueClient get auth => client.auth;
}
```

Update file `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'src/core/supabase_config.dart';
import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  await SupabaseConfig.initialize();

  runApp(const MyApp());
}
```

### 6. Implementasi Authentication

#### a. Service Layer

Buat `lib/src/services/auth_service.dart`:

```dart
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
    required String fullName,
  }) async {
    return await _auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
      },
    );
  }

  // Login dengan email dan password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithPassword(
      email: email,
      password: password,
    );
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
    return await _auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }
}
```

#### b. Implementasi di Login Screen

Update `lib/src/features/auth/screens/login_screen.dart`:

```dart
import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  // ... kode existing
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await _authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (response.user != null) {
        // Login berhasil, navigate ke home
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } on AuthException catch (e) {
      // Handle error dari Supabase
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login gagal: ${e.message}')),
        );
      }
    } catch (e) {
      // Handle error lainnya
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ... rest of the code
}
```

#### c. Implementasi di Register Screen

Update `lib/src/features/auth/screens/register_screen.dart`:

```dart
Future<void> _handleRegister() async {
  if (!_formKey.currentState!.validate()) return;

  if (_passwordController.text != _confirmPasswordController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password tidak cocok')),
    );
    return;
  }

  setState(() => _isLoading = true);

  try {
    final response = await _authService.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      fullName: _fullNameController.text.trim(),
    );

    if (response.user != null) {
      // Register berhasil
      if (mounted) {
        // Jika email confirmation aktif, tampilkan pesan
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi berhasil! Silakan cek email untuk verifikasi.'),
          ),
        );
        Navigator.pop(context); // Kembali ke login
      }
    }
  } on AuthException catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registrasi gagal: ${e.message}')),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
```

## 📊 Penjelasan Schema Database

### Tabel `profiles`

| Kolom        | Tipe        | Deskripsi                                  |
| ------------ | ----------- | ------------------------------------------ |
| `id`         | UUID        | Primary key, reference ke `auth.users(id)` |
| `email`      | TEXT        | Email user (unique)                        |
| `full_name`  | TEXT        | Nama lengkap user                          |
| `avatar_url` | TEXT        | URL foto profile (opsional)                |
| `created_at` | TIMESTAMPTZ | Waktu profile dibuat                       |
| `updated_at` | TIMESTAMPTZ | Waktu profile terakhir di-update           |

**Fitur Otomatis**:

- ✅ Profile otomatis dibuat saat user register (via trigger)
- ✅ `updated_at` otomatis diupdate saat data berubah
- ✅ Row Level Security (RLS) aktif untuk keamanan data
- ✅ User hanya bisa akses dan update profile mereka sendiri

### Tabel `user_sessions` (Opsional)

Digunakan untuk tracking login history user:
| Kolom | Tipe | Deskripsi |
|-------|------|-----------|
| `id` | UUID | Primary key |
| `user_id` | UUID | Reference ke `profiles(id)` |
| `device_info` | TEXT | Info device yang digunakan login |
| `ip_address` | TEXT | IP address saat login |
| `login_at` | TIMESTAMPTZ | Waktu login |
| `logout_at` | TIMESTAMPTZ | Waktu logout (nullable) |

## 🔒 Security Features

### Row Level Security (RLS)

Semua tabel menggunakan RLS dengan policies:

- **SELECT**: User hanya bisa melihat data mereka sendiri
- **INSERT**: User hanya bisa insert data mereka sendiri
- **UPDATE**: User hanya bisa update data mereka sendiri
- **DELETE**: Otomatis cascade delete saat user dihapus

### Authentication

- ✅ Email/Password authentication
- ✅ Email confirmation (optional)
- ✅ Password reset via email
- ✅ Secure session management
- ✅ JWT-based tokens

## 🧪 Testing

### Test Registration

1. Jalankan aplikasi Flutter
2. Buka screen Register
3. Isi form dengan data valid
4. Klik tombol Register
5. Periksa di Supabase Dashboard > Authentication > Users
6. User baru harus muncul di list
7. Periksa di Table Editor > profiles, data profile harus otomatis dibuat

### Test Login

1. Gunakan email dan password yang sudah didaftarkan
2. Klik tombol Login
3. Jika berhasil, aplikasi akan navigate ke home screen
4. Check session dengan `SupabaseConfig.auth.currentUser`

### Test RLS

1. Login dengan user A
2. Coba query `profiles` table
3. Pastikan hanya bisa melihat data user A saja
4. Tidak bisa melihat data user lain

## 📝 Catatan Penting

### Environment Variables

- ⚠️ **JANGAN** commit file `.env` ke Git
- ✅ Pastikan `.env` ada di `.gitignore`
- ✅ Share `.env.example` untuk dokumentasi
- ✅ Gunakan `.env` berbeda untuk development dan production

### Error Handling

Common error codes:

- `invalid_credentials` - Email/password salah
- `email_not_confirmed` - Email belum diverifikasi
- `user_already_exists` - Email sudah terdaftar
- `weak_password` - Password terlalu lemah (min 6 karakter)

### Best Practices

1. ✅ Selalu validate input sebelum kirim ke Supabase
2. ✅ Handle loading state saat proses auth
3. ✅ Tampilkan error message yang user-friendly
4. ✅ Gunakan try-catch untuk error handling
5. ✅ Check auth state sebelum navigate ke protected routes

## 🚀 Next Steps

1. [ ] Setup Supabase project dan dapatkan credentials
2. [ ] Buat file `.env` dengan credentials Supabase
3. [ ] Jalankan SQL schema di Supabase Dashboard
4. [ ] Buat file `supabase_config.dart`
5. [ ] Update `main.dart` untuk initialize Supabase
6. [ ] Buat `auth_service.dart`
7. [ ] Implementasi login dan register di screens
8. [ ] Test registration dan login
9. [ ] Setup auth state management (optional: Provider/Riverpod)
10. [ ] Implementasi protected routes

## 📚 Resources

- [Supabase Flutter Docs](https://supabase.com/docs/reference/dart/introduction)
- [Supabase Auth Docs](https://supabase.com/docs/guides/auth)
- [Flutter Dotenv](https://pub.dev/packages/flutter_dotenv)
- [Supabase Dashboard](https://app.supabase.com)

---

**Selamat! Setup Supabase untuk authentication sudah siap digunakan! 🎉**
