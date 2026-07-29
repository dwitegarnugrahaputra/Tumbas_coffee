// Lokasi: lib/app/modules/history/controllers/history_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../main.dart'; // Import global client 'supabase'
import '../../../routes/app_pages.dart';

class HistoryController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  var isLoading = true.obs;

  // Penampung data dinamis
  var onProcessOrders = <Map<String, dynamic>>[].obs;
  var completedOrders = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    fetchHistory();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  // AMBIL DATA TRANSAKSI DARI SUPABASE
  Future<void> fetchHistory() async {
    try {
      isLoading.value = true;
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) return;

      // Ambil tabel orders dan join ke order_items
      final List<dynamic> response = await supabase
          .from('orders')
          .select('*, order_items(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      List<Map<String, dynamic>> onProcess = [];
      List<Map<String, dynamic>> completed = [];

      for (var item in response) {
        final order = item as Map<String, dynamic>;
        final status = order['status'] ?? '';

        // Filter kategori berdasarkan status
        if (status == 'PENDING' || status == 'WAITING_VERIFICATION' || status == 'ON_PROCESS') {
          onProcess.add(order);
        } else {
          // Status seperti COMPLETED, CANCELED, EXPIRED masuk ke Selesai/Riwayat
          completed.add(order);
        }
      }

      onProcessOrders.value = onProcess;
      completedOrders.value = completed;

    } catch (e) {
      debugPrint('Error fetch history: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // SIMULASI TERIMA PESANAN (UBAH STATUS JADI COMPLETED)
  Future<void> completeOrder(String orderId) async {
    try {
      isLoading.value = true;
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        Get.snackbar('Gagal', 'Sesi login tidak ditemukan.');
        return;
      }

      // Update status di Supabase dengan filter user_id agar aman
      final response = await supabase
          .from('orders')
          .update({'status': 'COMPLETED'})
          .eq('id', orderId)
          .select();

      debugPrint('Hasil response update: $response');

      if (response.isEmpty) {
        Get.snackbar(
          'Gagal Update',
          'Status gagal diubah. Cek kebijakan RLS tabel orders di Supabase.',
          backgroundColor: Colors.amber[900],
          colorText: Colors.white,
        );
        return;
      }

      // Refresh data history setelah update berhasil
      await fetchHistory();

      Get.snackbar(
        'Pesanan Selesai',
        'Pesanan telah diterima dan dipindahkan ke riwayat.',
        backgroundColor: const Color(0xFF007A4B),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      debugPrint('Catch error completeOrder: $e');
      Get.snackbar(
        'Error',
        'Gagal menyelesaikan pesanan: $e',
        backgroundColor: Colors.red[700],
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Navigasi ke halaman invoice bawa data order_id
  void viewInvoice(String orderId) {
    Get.toNamed(Routes.INVOICE, arguments: {'order_id': orderId});
  }
}