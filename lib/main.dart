// Lokasi: lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/routes/app_pages.dart';

// Helper global shortcut biar gampang panggil Supabase di controller/view mana aja
final supabase = Supabase.instance.client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inisialisasi Format Tanggal Bahasa Indonesia (Fix Locale Exception)
  await initializeDateFormatting('id_ID', null);

  // 2. Inisialisasi Supabase Backend
  await Supabase.initialize(
    url: 'https://nwqweycjdaaadhcuuxdx.supabase.co', // Ganti dengan Project URL dari Supabase kamu
    anonKey: 'sb_publishable_jHKcqcuoptyrqiRyynHRTw_tLKUK8iO', // Tempel Publishable Key kamu di sini!
  );

  runApp(
    GetMaterialApp(
      title: "Tumbas Kopi",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}