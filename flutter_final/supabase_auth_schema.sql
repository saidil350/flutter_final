-- ============================================
-- SUPABASE AUTHENTICATION SCHEMA
-- Untuk Projek Flutter Final
-- ============================================

-- 1. Buat tabel profiles untuk menyimpan data user tambahan
-- Tabel ini akan otomatis tersinkron dengan auth.users dari Supabase
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);
-- 2. Nonaktifkan Row Level Security (RLS) untuk tabel profiles
ALTER TABLE public.profiles DISABLE ROW LEVEL SECURITY;

-- 3. Buat policy untuk profiles - User hanya bisa melihat profile mereka sendiri
CREATE POLICY "Users can view own profile" 
  ON public.profiles 
  FOR SELECT 
  USING (auth.uid() = id);

-- 4. Buat policy untuk profiles - User bisa update profile mereka sendiri
CREATE POLICY "Users can update own profile" 
  ON public.profiles 
  FOR UPDATE 
  USING (auth.uid() = id);

-- 5. Buat policy untuk profiles - User bisa insert profile mereka sendiri
CREATE POLICY "Users can insert own profile" 
  ON public.profiles 
  FOR INSERT 
  WITH CHECK (auth.uid() = id);

-- 6. Buat function untuk otomatis membuat profile saat user register
CREATE OR REPLACE FUNCTION public.handle_new_user() 
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, avatar_url)
  VALUES (
    NEW.id, 
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    COALESCE(NEW.raw_user_meta_data->>'avatar_url', '')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 7. Buat trigger untuk execute function di atas saat user baru dibuat
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 8. Buat function untuk update timestamp updated_at secara otomatis
CREATE OR REPLACE FUNCTION public.handle_updated_at() 
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = timezone('utc'::text, now());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 9. Buat trigger untuk update timestamp
DROP TRIGGER IF EXISTS on_profile_updated ON public.profiles;
CREATE TRIGGER on_profile_updated
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- ============================================
-- OPTIONAL: Tabel tambahan untuk fitur lain
-- ============================================

-- Tabel untuk menyimpan session history (opsional)
CREATE TABLE IF NOT EXISTS public.user_sessions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  device_info TEXT,
  ip_address TEXT,
  login_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  logout_at TIMESTAMP WITH TIME ZONE
);

-- Enable RLS untuk user_sessions
ALTER TABLE public.user_sessions ENABLE ROW LEVEL SECURITY;

-- Policy untuk user_sessions
CREATE POLICY "Users can view own sessions" 
  ON public.user_sessions 
  FOR SELECT 
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own sessions" 
  ON public.user_sessions 
  FOR INSERT 
  WITH CHECK (auth.uid() = user_id);

-- ============================================
-- INDEXES untuk performa query
-- ============================================
CREATE INDEX IF NOT EXISTS idx_profiles_email ON public.profiles(email);
CREATE INDEX IF NOT EXISTS idx_user_sessions_user_id ON public.user_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_user_sessions_login_at ON public.user_sessions(login_at DESC);

-- ============================================
-- AKHIR SCHEMA
-- ============================================

-- CATATAN PENGGUNAAN:
-- 1. Copy seluruh SQL ini ke Supabase Dashboard > SQL Editor
-- 2. Jalankan SQL untuk membuat semua tabel, policies, triggers, dan functions
-- 3. Tabel profiles akan otomatis diisi saat user baru register melalui Flutter app
-- 4. Email confirmation dan password reset sudah di-handle oleh Supabase Auth secara default
-- 5. Untuk mengaktifkan email confirmation:
--    - Pergi ke Authentication > Settings > Email Auth
--    - Enable "Confirm email" jika diperlukan
