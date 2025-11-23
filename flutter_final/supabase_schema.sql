-- ==============================================================================
-- SUPABASE SCHEMA SCRIPT FOR FLUTTER FINANCE APP
-- ==============================================================================
-- Deskripsi:
-- Script ini membuat struktur database lengkap untuk aplikasi finance Anda.
-- Meliputi tabel Users, Transactions, dan Savings.
-- Fitur RLS (Row Level Security) dimatikan sesuai permintaan ("no rls").
-- ==============================================================================

-- 1. TABEL USERS (Menyimpan data profil user)
-- ------------------------------------------------------------------------------
create table if not exists public.users (
  id uuid references auth.users on delete cascade not null primary key,
  email text,
  nama text,
  kelas text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Matikan RLS untuk users
alter table public.users disable row level security;


-- 2. TABEL TRANSACTIONS (Menyimpan data pemasukan & pengeluaran)
-- ------------------------------------------------------------------------------
create table if not exists public.transactions (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.users(id) on delete cascade not null,
  title text not null,          -- Contoh: "Adobe Illustrator"
  subtitle text,                -- Contoh: "Subscription fee"
  amount numeric not null,      -- Nominal uang (simpan angka murni, bukan string "Rp...")
  is_negative boolean default true, -- true = Pengeluaran, false = Pemasukan
  category text,                -- Contoh: "Langganan", "Belanja", "Pendapatan"
  date timestamp with time zone default timezone('utc'::text, now()) not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Matikan RLS untuk transactions
alter table public.transactions disable row level security;


-- 3. TABEL SAVINGS (Menyimpan data tabungan/goals)
-- ------------------------------------------------------------------------------
create table if not exists public.savings (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.users(id) on delete cascade not null,
  title text not null,          -- Contoh: "Iphone 13 Mini"
  current_amount numeric default 0,
  target_amount numeric not null,
  color_hex text,               -- Menyimpan kode warna (misal: "0xFFE55039")
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Matikan RLS untuk savings
alter table public.savings disable row level security;


-- 4. AUTOMATION (Trigger untuk User Baru)
-- ------------------------------------------------------------------------------
-- Fungsi ini akan otomatis jalan setiap kali ada user baru yang Sign Up
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.users (id, email, nama, kelas)
  values (
    new.id,
    new.email,
    new.raw_user_meta_data->>'nama',
    new.raw_user_meta_data->>'kelas'
  );
  return new;
end;
$$ language plpgsql security definer;

-- Trigger yang memanggil fungsi di atas
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();


-- ==============================================================================
-- PANDUAN PENGGUNAAN DI FLUTTER
-- ==============================================================================
/*
1. MENGAMBIL DATA USER:
   final user = await supabase.from('users').select().eq('id', userId).single();

2. MENAMBAH TRANSAKSI:
   await supabase.from('transactions').insert({
     'user_id': userId,
     'title': 'Makan Siang',
     'subtitle': 'Warung Tegal',
     'amount': 15000,
     'is_negative': true,
     'category': 'Makan',
     'date': DateTime.now().toIso8601String(),
   });

3. MENGAMBIL TRANSAKSI (History):
   final data = await supabase.from('transactions')
       .select()
       .eq('user_id', userId)
       .order('date', ascending: false);

4. MENAMBAH TABUNGAN:
   await supabase.from('savings').insert({
     'user_id': userId,
     'title': 'Beli Laptop',
     'target_amount': 15000000,
     'color_hex': '0xFF377CC8',
   });
*/
