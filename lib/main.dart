// Lokasi: lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart'; // Import untuk fix locale error
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fix locale Bahasa Indonesia untuk DateFormat
  await initializeDateFormatting('id_ID', null);

  runApp(
    GetMaterialApp(
      title: "Tumbas Kopi",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}