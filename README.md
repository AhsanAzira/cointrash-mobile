# ♻️ CoinTrash Mobile (MVP)

> **Ubah sampahmu menjadi koin, tukarkan dengan hadiah menarik!** > CoinTrash adalah aplikasi mobile inovatif yang mengintegrasikan sistem pengelolaan sampah dengan insentif koin digital. Proyek ini dibangun sebagai *Minimum Viable Product (MVP)* untuk memvalidasi model bisnis pengelolaan sampah berkelanjutan.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![PHP](https://img.shields.io/badge/PHP-777BB4?style=for-the-badge&logo=php&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-00000F?style=for-the-badge&logo=mysql&logoColor=white)


## 🚀 Fitur Utama

Aplikasi MVP ini telah mendukung integrasi *End-to-End* (Client-Server) dengan fitur-fitur berikut:
* **Autentikasi Pengguna:** Sistem Sign In dan Sign Up yang terhubung langsung ke database MySQL.
* **Dashboard Cerdas:** Menampilkan level progres pengguna, total kontribusi sampah (kg), dan pembaruan harga sampah secara *real-time* dari server.
* **Manajemen Dompet (Point Screen):** Cek saldo koin dan riwayat setoran sampah. Didukung fitur *Pull-to-Refresh* untuk sinkronisasi data instan.
* **Simulasi Scan Sampah:** Prototipe fitur pemindai sampah (menggunakan kamera) yang mensimulasikan pendeteksian jenis sampah dan beratnya untuk diklaim menjadi koin.
* **Peta Lokasi Drop-off:** Menampilkan daftar stand/TPS CoinTrash terdekat (Fokus area ULM Banjarmasin & Banjarbaru) menggunakan `flutter_map`.

---

## ⚙️ Teknologi yang Digunakan

* **Frontend:** Flutter & Dart
* **State Management:** `ChangeNotifier` (Provider Pattern via `store.dart`)
* **Backend API:** PHP Native (Action-Based HTTP API)
* **Database:** MySQL (XAMPP Server)
* **UI/UX:** `flutter_animate` untuk transisi halus dan `percent_indicator` untuk visualisasi progres.

---

## 💼 Model Bisnis (AARRR Funnel)

Sebagai bagian dari proyek *Startup Business*, CoinTrash memiliki dua pilar pendapatan utama:
1. **Platform Margin (Bagi Hasil):** Menerapkan rasio 65:35. Pengguna mendapat 65% nilai sampah dalam bentuk koin, dan 35% menjadi margin operasional (*Acquisition & Retention*).
2. **Upcycled E-Commerce:** Mendaur ulang sampah menjadi barang bernilai guna yang dijual di aplikasi menggunakan Koin atau Uang Asli (*Revenue & Referral*).

---

## 🛠️ Panduan Instalasi (Getting Started)

Ikuti langkah-langkah berikut untuk menjalankan aplikasi secara lokal.

### Prasyarat:
* [Flutter SDK](https://docs.flutter.dev/get-started/install) terinstal di mesin kamu.
* [XAMPP](https://www.apachefriends.org/) (untuk menjalankan Apache & MySQL).
* Android Studio / VS Code dengan emulator Android.

### Langkah-langkah:
1. **Clone Repositori:**
   ```bash
   git clone [https://github.com/AhsanAzira/cointrash-mobile.git](https://github.com/AhsanAzira/cointrash-mobile.git)
   cd cointrash-mobile
