// Lokasi: lib/app/modules/payment_confirmation/controllers/payment_confirmation_controller.dart

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../main.dart'; // Import global client 'supabase'
import '../../order/controllers/order_controller.dart';
import '../../../routes/app_pages.dart';

class PaymentConfirmationController extends GetxController {
  // State Reactive
  var isUploading = false.obs;
  var selectedImagePath = ''.obs;
  var orderData = <String, dynamic>{}.obs;

  // State Virtual Account & Timer
  var virtualAccountCode = ''.obs;
  var remainingSeconds = 300.obs; // 5 Menit = 300 detik
  var isExpired = false.obs;
  Timer? _timer;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    // Tangkap data payload dari Checkout
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      orderData.assignAll(Get.arguments as Map<String, dynamic>);
    }

    _generateVirtualAccount();
    _startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // A. GENERATE VIRTUAL ACCOUNT CODE
  void _generateVirtualAccount() {
    // Format VA: Prefix Bank + 10-12 Digit Acak
    final random = Random();
    String randomDigits = List.generate(10, (_) => random.nextInt(10)).join();
    virtualAccountCode.value = '8808$randomDigits';
  }

  // B. TIMER COUNTDOWN 5 MENIT
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        isExpired.value = true;
        _timer?.cancel();
        _showExpiredDialog();
      }
    });
  }

  // Formatter untuk mm:ss
  String get formattedTime {
    int minutes = remainingSeconds.value ~/ 60;
    int seconds = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // C. SALIN KODE VA KE CLIPBOARD
  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Berhasil',
      'Nomor Virtual Account disalin!',
      backgroundColor: const Color(0xFF007A4B),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  // D. DIALOG EXPIRATION (WAKTU HABIS)
  void _showExpiredDialog() {
    Get.defaultDialog(
      title: 'Waktu Habis!',
      middleText: 'Batas waktu pembayaran 5 menit telah berakhir. Transaksi dibatalkan.',
      textConfirm: 'Kembali',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red[700],
      barrierDismissible: false,
      onConfirm: () {
        Get.back(); // Close dialog
        Get.back(); // Kembali ke halaman sebelumnya
      },
    );
  }

  // E. PICK IMAGE DARI GALERI
  Future<void> pickImage() async {
    if (isExpired.value) return;

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImagePath.value = image.path;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memilih gambar dari galeri: $e',
        backgroundColor: Colors.red[700],
        colorText: Colors.white,
      );
    }
  }

  // F. REMOVE IMAGE TERPILIH
  void removeImage() {
    selectedImagePath.value = '';
  }

  // G. SUBMIT PAYMENT PROOF
  Future<void> submitPaymentProof() async {
    if (isExpired.value) {
      Get.snackbar(
        'Transaksi Kadaluwarsa',
        'Waktu pembayaran telah habis!',
        backgroundColor: Colors.red[700],
        colorText: Colors.white,
      );
      return;
    }

    if (selectedImagePath.value.isEmpty) {
      Get.snackbar(
        'Unggah Bukti',
        'Harap unggah bukti transfer sebelum melanjutkan!',
        backgroundColor: Colors.amber[800],
        colorText: Colors.white,
      );
      return;
    }

    try {
      isUploading.value = true;

      final user = supabase.auth.currentUser;
      if (user == null) {
        Get.snackbar(
          'Gagal Transaksi',
          'Sesi login tidak ditemukan. Silakan re-login.',
          backgroundColor: Colors.red[700],
          colorText: Colors.white,
        );
        return;
      }

      final file = File(selectedImagePath.value);
      final fileExt = selectedImagePath.value.split('.').last;
      final fileName = '${user.id}_${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = 'proofs/$fileName';

      // 1. Upload Gambar ke Supabase Storage
      String imageUrl = '';
      try {
        await supabase.storage.from('payment_proofs').upload(filePath, file);
        imageUrl = supabase.storage.from('payment_proofs').getPublicUrl(filePath);
      } catch (storageErr) {
        print('Upload storage log: $storageErr');
      }

      final paymentMethod = orderData['payment_method'] as Map<String, dynamic>?;
      final items = (orderData['items'] as List<dynamic>?) ?? [];

      // 2. Insert ke Tabel 'orders'
      final orderResponse = await supabase.from('orders').insert({
        'user_id': user.id,
        'customer_name': orderData['customer_name'] ?? 'Customer',
        'total_price': orderData['total'] ?? 0,
        'subtotal': orderData['subtotal'] ?? 0,
        'delivery_fee': orderData['delivery_fee'] ?? 0,
        'delivery_address': orderData['address'] ?? '',
        'address_note': orderData['address_note'] ?? '',
        'latitude': orderData['latitude'] ?? 0.0,
        'longitude': orderData['longitude'] ?? 0.0,
        'payment_method_id': paymentMethod?['id'],
        'payment_method_name': paymentMethod?['name'] ?? 'Virtual Account',
        'va_number': virtualAccountCode.value,
        'payment_proof_url': imageUrl.isNotEmpty ? imageUrl : selectedImagePath.value,
        'status': 'WAITING_VERIFICATION', // Diubah agar sesuai flow manual verification
      }).select().single();

      final String orderId = orderResponse['id'];

      // 3. Insert ke Tabel 'order_items'
      if (items.isNotEmpty) {
        final List<Map<String, dynamic>> orderItemsPayload = items.map((item) {
          return {
            'order_id': orderId,
            'product_id': item['product_id'],
            'product_name': item['name'],
            'quantity': item['quantity'],
            'price': item['price'],
          };
        }).toList();

        await supabase.from('order_items').insert(orderItemsPayload);
      }

      // Matikan Timer jika sukses upload
      _timer?.cancel();

      // Clear Cart
      if (Get.isRegistered<OrderController>()) {
        Get.find<OrderController>().cart.clear();
      }

      Get.snackbar(
        'Berhasil!',
        'Bukti pembayaran berhasil dikirim dan transaksi telah disimpan!',
        backgroundColor: const Color(0xFF007A4B),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      // Redirect ke Invoice
      Get.offAllNamed(Routes.INVOICE, arguments: {'order_id': orderId});

    } catch (e) {
      Get.snackbar(
        'Error Transaksi',
        'Gagal memproses transaksi: $e',
        backgroundColor: Colors.red[700],
        colorText: Colors.white,
      );
    } finally {
      isUploading.value = false;
    }
  }
}