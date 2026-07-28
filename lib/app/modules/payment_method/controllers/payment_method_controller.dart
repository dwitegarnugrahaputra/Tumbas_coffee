// Lokasi: lib/app/modules/payment_method/controllers/payment_method_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../main.dart'; // Import global client 'supabase'
import '../../../routes/app_pages.dart';

class PaymentMethodController extends GetxController {
  // State Reactive List Metode Pembayaran dari Database
  var paymentMethods = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  // State Metode Pembayaran Terpilih (Default/Selected)
  var selectedPaymentMethod = <String, dynamic>{}.obs;

  // Data Payload dari Checkout Page
  var checkoutData = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();

    // Tangkap arguments data transaksi yang di-pass dari CheckoutController
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      checkoutData.assignAll(Get.arguments as Map<String, dynamic>);
    }

    fetchPaymentMethodsFromSupabase();
  }

  // 1. FETCH METODE PEMBAYARAN DARI SUPABASE
  Future<void> fetchPaymentMethodsFromSupabase() async {
    try {
      isLoading.value = true;

      final List<dynamic> response = await supabase
          .from('payment_methods')
          .select()
          .eq('is_active', true)
          .order('category', ascending: true);

      paymentMethods.value = List<Map<String, dynamic>>.from(response);

      // Set default terpilih ke metode pertama jika ada (pakai assignAll biar bebas warning)
      if (paymentMethods.isNotEmpty && selectedPaymentMethod.isEmpty) {
        selectedPaymentMethod.assignAll(paymentMethods.first);
      }
    } catch (e) {
      Get.snackbar(
        'Error Pembayaran',
        'Gagal memuat metode pembayaran: $e',
        backgroundColor: Colors.red[700],
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 2. PILIH METODE PEMBAYARAN
  void selectPaymentMethod(Map<String, dynamic> method) {
    selectedPaymentMethod.assignAll(method);
  }

  // 3. KONFIRMASI PEMBAYARAN DAN LANJUT KE PAYMENT CONFIRMATION
  void confirmSelection() {
    if (selectedPaymentMethod.isEmpty) {
      Get.snackbar(
        'Pilih Pembayaran',
        'Silakan pilih salah satu metode pembayaran!',
        backgroundColor: Colors.amber[800],
        colorText: Colors.white,
      );
      return;
    }

    // Gabungkan data checkout dengan metode pembayaran terpilih
    final Map<String, dynamic> finalOrderPayload = {
      ...checkoutData,
      'payment_method': selectedPaymentMethod,
    };

    // Lanjut ke Halaman Payment Confirmation
    Get.toNamed(Routes.PAYMENT_CONFIRMATION, arguments: finalOrderPayload);
  }
}