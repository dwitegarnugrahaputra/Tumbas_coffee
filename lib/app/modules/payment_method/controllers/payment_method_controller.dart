import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../../routes/app_pages.dart';

class PaymentMethodController extends GetxController {
  var selectedMethod = 'GoPay'.obs;

  // Bikin dinamis nomor pembayarannya berdasarkan metode yang dipilih
  String get virtualAccount {
    switch (selectedMethod.value) {
      case 'BCA Virtual Account': return '3901-2345-6789';
      case 'Mandiri Virtual Account': return '8950-8000-1234';
      case 'BNI Virtual Account': return '8241-0022-3344';
      case 'BRI Virtual Account': return '2273-1000-5566';
      case 'GoPay': return '0812-3456-7890';
      case 'OVO': return '0812-3456-7890';
      case 'Dana': return '0812-3456-7890';
      case 'ShopeePay': return '112-0812-3456-7890';
      default: return '0812-3456-7890';
    }
  }

  void setPaymentMethod(String method) {
    selectedMethod.value = method;
  }

  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: virtualAccount));
    Get.snackbar(
      'Berhasil',
      'Nomor pembayaran ${selectedMethod.value} berhasil disalin!',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  void goToConfirmation() {
    Get.toNamed(Routes.PAYMENT_CONFIRMATION);
  }
}