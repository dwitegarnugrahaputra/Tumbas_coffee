// Lokasi: lib/app/modules/invoice/controllers/invoice_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../main.dart'; // Import global client 'supabase'
import '../../../routes/app_pages.dart';
import 'dart:typed_data'; // Tambahkan ini untuk Uint8List
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';

class InvoiceController extends GetxController {
  final GlobalKey invoiceKey = GlobalKey();

  var isLoading = true.obs;
  var isSaving = false.obs;

  var orderData = <String, dynamic>{}.obs;
  var orderItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrderDetail();
  }

  // Ambil detail order dari Supabase
  Future<void> fetchOrderDetail() async {
    try {
      isLoading.value = true;

      // Tangkap order_id dari arguments
      final String? orderId = Get.arguments?['order_id'];

      if (orderId == null || orderId.isEmpty) {
        Get.snackbar('Error', 'ID Transaksi tidak ditemukan!');
        return;
      }

      // 1. Fetch data dari tabel 'orders'
      final orderRes = await supabase
          .from('orders')
          .select()
          .eq('id', orderId)
          .single();

      orderData.value = orderRes;

      // 2. Fetch data dari tabel 'order_items'
      final itemsRes = await supabase
          .from('order_items')
          .select()
          .eq('order_id', orderId);

      orderItems.value = List<Map<String, dynamic>>.from(itemsRes);

    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil data invoice: $e',
        backgroundColor: Colors.red[700],
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Kembali ke Beranda / Main Navigation
  void backToHome() {
    Get.offAllNamed(Routes.MAIN); // Pastikan nama route disesuaikan dengan route utama lu (misal: Routes.HOME / DASHBOARD)
  }

  // Simpan Invoice sebagai Gambar
  Future<void> saveInvoice() async {
    try {
      isSaving.value = true;

      // 1. Cari RenderRepaintBoundary berdasarkan GlobalKey invoiceKey
      RenderRepaintBoundary? boundary = invoiceKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        Get.snackbar(
          'Gagal',
          'Gagal memproses tampilan struk.',
          backgroundColor: Colors.red[700],
          colorText: Colors.white,
        );
        return;
      }

      // 2. Render Boundary menjadi Gambar (PNG byte array)
      ui.Image image = await boundary.toImage(pixelRatio: 3.0); // Ratio tinggi agar gambar tajam/HD
      var byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        final Uint8List pngBytes = byteData.buffer.asUint8List();

        try {
          // Simpan Byte Gambar ke Galeri HP pakai package 'gal'
          await Gal.putImageBytes(pngBytes);

          Get.snackbar(
            'Berhasil!',
            'Bukti transaksi berhasil disimpan ke galeri HP.',
            backgroundColor: const Color(0xFF007A4B),
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        } on GalException catch (e) {
          Get.snackbar(
            'Gagal Menyimpan',
            'Error dari Galeri: ${e.type.message}',
            backgroundColor: Colors.red[700],
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat menyimpan: $e',
        backgroundColor: Colors.red[700],
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }
}