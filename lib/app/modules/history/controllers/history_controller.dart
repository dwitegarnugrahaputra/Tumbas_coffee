import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    // Bikin 2 tab: Dalam Proses & Selesai
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  // Nanti dipake buat navigasi lihat bukti
  void viewInvoice(String invId) {
    // Arahkan ke halaman detail riwayat / invoice
    print("Melihat invoice: $invId");
  }
}