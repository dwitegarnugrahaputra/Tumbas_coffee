// Lokasi: lib/app/modules/invoice/controllers/invoice_controller.dart

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:gal/gal.dart'; // Import paket gal
import '../../../routes/app_pages.dart';

class InvoiceController extends GetxController {
  final GlobalKey invoiceKey = GlobalKey();
  var isSaving = false.obs;

  void backToHome() {
    Get.offAllNamed(Routes.HOME);
  }

  Future<void> saveInvoice() async {
    try {
      isSaving.value = true;

      // 1. Tangkap RenderObject dari RepaintBoundary
      RenderRepaintBoundary? boundary =
      invoiceKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        Get.snackbar('Gagal', 'Gagal memproses gambar invoice.');
        isSaving.value = false;
        return;
      }

      // 2. Convert Widget menjadi Image Pixel (Pixel Ratio 3.0 agar jernih)
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      var byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        final buffer = byteData.buffer.asUint8List();

        // 3. Simpan byte gambar LANGSUNG KE GALERI HP
        await Gal.putImageBytes(
          buffer,
          name: 'Invoice_TumbasKopi_${DateTime.now().millisecondsSinceEpoch}',
        );

        Get.snackbar(
          'Berhasil Disimpan',
          'Bukti transaksi berhasil disimpan ke Galeri HP kamu!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF007A4B),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Gagal Menyimpan',
        'Izin galeri ditolak atau terjadi error: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }
}