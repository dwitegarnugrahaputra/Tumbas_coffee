# ☕ Tumbas Kopi - Mobile App

Aplikasi mobile e-commerce *customer-side* berbasis lokasi yang dirancang untuk memudahkan pelanggan memesan kopi dan *pastry* secara online. Proyek ini dibangun menggunakan **Flutter** dengan arsitektur **GetX**, dan menggunakan **Supabase** sebagai *Backend-as-a-Service* (BaaS).

Proyek ini juga ditujukan sebagai pemenuhan unit kompetensi untuk Sertifikasi **Junior Mobile Programmer BNSP**.

---

## 🛠️ Tech Stack & Architecture

| Komponen | Teknologi / Tools | Deskripsi |
| --- | --- | --- |
| **Mobile Framework** | Flutter | Cross-platform framework |
| **State Management** | GetX | State, Dependency, & Route Management |
| **Backend & DB** | Supabase | PostgreSQL, Authentication, & Cloud Storage |
| **Location Service** | `geolocator` | Mendapatkan titik koordinat GPS peranti (Lat, Long) |
| **Date & Currency** | `intl` | Formatting tanggal transaksi dan angka Rupiah (IDR) |

---

## ✨ Fitur Utama

1. **Authentication & Activity Log 🔐**
    - Autentikasi aman menggunakan Supabase Auth (Email & Password).
    - **Mobile Security & Audit:** Pencatatan aktivitas login secara otomatis ke dalam tabel `user_logs` beserta *timestamp*.

2. **Catalog & Product Detail 🛍️**
    - Daftar menu terbagi dalam kategori: *Espresso*, *Non-Coffee*, dan *Pastry*.
    - Detail produk menampilkan deskripsi, harga (terformat IDR), dan kontrol kuantitas.
    - Manajemen *state* keranjang (*cart*) yang reaktif menggunakan GetX.

3. **Checkout & Location Based Service (LBS) 📍**
    - **GPS Fetcher:** Mengintegrasikan `geolocator` untuk menangkap koordinat presisi pengguna (Latitude & Longitude) secara otomatis saat *checkout*.
    - Input catatan detail alamat pengiriman.
    - Sinkronisasi transaksional ke database (`orders` dan `order_items`).

4. **Transaction Receipt & History 🧾**
    - **Digital Invoice:** Bukti transaksi digital bergaya struk (*receipt*) yang memuat ID Transaksi unik (UUID), titik koordinat pengiriman, dan rincian biaya.
    - Riwayat pesanan pengguna yang persisten berdasarkan `user_id`.

---

## 🎨 Design System & UI/UX

Aplikasi ini menggunakan pendekatan UI yang *clean* dan modern dengan palet warna bernuansa **Sage & Earthy Tone**:

- 🟢 **Primary / Main Accent:** `#93AB7D` (Sage Green) - *App Bar, Active Icon, Primary Buttons*
- 🌿 **Secondary Accent:** `#5F8563` (Medium Green) - *Hover States, Badge Status*
- 🌲 **Dark Accent:** `#2D5545` (Deep Forest Green) - *Text Headlines, Selected Cards*
- 🌑 **Dark Neutral:** `#273238` (Dark Slate) - *Body Text, Unselected Icons*
- ⚪ **Background Light:** `#F7F9F6` (Soft Off-White) - *Screen Background*

Navigasi menggunakan **Bottom Navigation Bar** persisten:
1. **Beranda:** Hero banner, quick category, best seller.
2. **Pesanan:** Katalog produk lengkap, pencarian, keranjang.
3. **Riwayat:** Riwayat transaksi & nota digital.
4. **Profil:** Info akun, Log Activity, Logout.

---

## 🗂️ Struktur Folder (GetX Pattern)

```text
lib/
├── app/
│   ├── data/
│   │   ├── models/           # Struktur data (Product, Order, UserLog, Profile)
│   │   ├── providers/        # Supabase API Call Services
│   │   └── repositories/     # Repository Pattern
│   ├── modules/
│   │   ├── auth/             # Layar Login/Register & AuthController
│   │   ├── main/             # Bottom Navigation & MainController
│   │   ├── home/             # Layar Beranda & HomeController
│   │   ├── order/            # Katalog, Kategori & OrderController
│   │   ├── checkout/         # Formulir LBS GPS & CheckoutController
│   │   ├── invoice/          # Layar Bukti Transaksi (Digital Receipt)
│   │   ├── history/          # Riwayat Pesanan & HistoryController
│   │   └── log_activity/     # Audit Log Layar & LogActivityController
│   ├── routes/
│   │   ├── app_pages.dart    # Konfigurasi halaman
│   │   └── app_routes.dart   # Penamaan rute
│   └── theme/
│       └── app_colors.dart   # Tema & Palet Warna
└── main.dart                 # Entry point, Inisialisasi Supabase & GetMaterialApp
```

---

## 🗄️ Skema Database (Supabase PostgreSQL)

Sistem menggunakan **Row Level Security (RLS)** untuk keamanan data dan diotomatisasi dengan *Database Triggers*.

1. **`profiles`**: Otomatis terbuat via *trigger* saat registrasi `auth.users`.
2. **`user_logs`**: Mencatat *audit trail* (misal: `LOGIN_SUCCESS`).
3. **`products`**: Etalase produk (Tumbas Kopi, Croissant, dll.).
4. **`orders`**: Header transaksi (Menyimpan Total Harga, Latitude, dan Longitude).
5. **`order_items`**: Detail produk yang dibeli di dalam satu transaksi.

---

## 🚀 Persiapan & Menjalankan Proyek

1. **Clone repository ini**
2. **Setup Environment Variables:**
   Pastikan Anda telah memasukkan kredensial Supabase (`SUPABASE_URL` dan `SUPABASE_ANON_KEY`) di dalam proyek.
3. **Install Dependencies:**
   ```bash
   flutter pub get
   ```
4. **Jalankan Aplikasi:**
   ```bash
   flutter run
   ```
   *(Pastikan memberikan izin akses lokasi/GPS pada emulator atau peranti fisik saat diminta).*