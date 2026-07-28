import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../routes/app_pages.dart';

class PaymentConfirmationController extends GetxController {
  // Obx variable untuk nyimpen path gambar yang dipilih
  var selectedImagePath = ''.obs;
  var isUploading = false.obs;

  final ImagePicker _picker = ImagePicker();

  // Fungsi buat buka galeri
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // Kompres dikit biar enteng
      );

      if (image != null) {
        selectedImagePath.value = image.path;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil gambar: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  // Fungsi hapus gambar kalau mau ganti
  void removeImage() {
    selectedImagePath.value = '';
  }

  // Fungsi submit bukti bayar
  Future<void> submitPaymentProof() async {
    if (selectedImagePath.value.isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Lu harus upload bukti transfer dulu cuy!',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isUploading.value = true;

    // Simulasi loading upload ke server (3 detik)
    await Future.delayed(const Duration(seconds: 3));

    isUploading.value = false;

    // Arahkan ke halaman Invoice (Pembayaran Berhasil)
    // Pake Get.offAllNamed biar user gak bisa back ke halaman upload lagi
    Get.offAllNamed(Routes.INVOICE);
  }
}