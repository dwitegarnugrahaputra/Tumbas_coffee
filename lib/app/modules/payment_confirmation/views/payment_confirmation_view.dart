// Lokasi: lib/app/modules/payment_confirmation/views/payment_confirmation_view.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/payment_confirmation_controller.dart';
import '../../../theme/app_colors.dart';

class PaymentConfirmationView extends GetView<PaymentConfirmationController> {
  const PaymentConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkAccent),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Konfirmasi Pembayaran',
          style: TextStyle(
              color: AppColors.darkAccent,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // ==========================================
            // 1. TIMER COUNTDOWN HEADER
            // ==========================================
            Obx(() {
              final isExpired = controller.isExpired.value;

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: isExpired ? Colors.red[50] : Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isExpired ? Colors.red.withOpacity(0.4) : Colors.orange.withOpacity(0.4),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: isExpired ? Colors.red[800] : Colors.orange[800],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isExpired ? 'Waktu Pembayaran Habis' : 'Selesaikan Pembayaran Dalam: ',
                      style: TextStyle(
                        color: isExpired ? Colors.red[800] : Colors.orange[900],
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    if (!isExpired)
                      Text(
                        controller.formattedTime,
                        style: TextStyle(
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),

            // ==========================================
            // 2. ALERT INFO
            // ==========================================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: Colors.green, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Sudah melakukan transfer? Unggah bukti pembayaran Anda di bawah ini agar pesanan segera diproses.',
                      style: TextStyle(
                          color: Colors.green[800], fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ==========================================
            // 3. CARD DETAIL VA & TOTAL PEMBAYARAN
            // ==========================================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Obx(() {
                final total = controller.orderData['total'] ?? 0;
                final paymentMethod =
                controller.orderData['payment_method'] as Map<String, dynamic>?;
                final paymentName = paymentMethod?['name']?.toString() ?? 'Mandiri Virtual Account';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Metode Pembayaran',
                            style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                        Text(
                          paymentName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // KODE VIRTUAL ACCOUNT
                    Text('Nomor Virtual Account',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.virtualAccountCode.value,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 1.2,
                            color: Colors.black87,
                          ),
                        ),
                        InkWell(
                          onTap: () => controller.copyToClipboard(controller.virtualAccountCode.value),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.darkAccent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'SALIN',
                              style: TextStyle(
                                color: AppColors.darkAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Pembayaran',
                            style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                        Text(
                          currencyFormatter.format(total),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: AppColors.darkAccent),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // 4. UPLOAD AREA
            // ==========================================
            Obx(() {
              final hasImage = controller.selectedImagePath.value.isNotEmpty;
              final isExpired = controller.isExpired.value;

              return GestureDetector(
                onTap: isExpired ? null : controller.pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: isExpired ? Colors.grey[100] : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: hasImage
                          ? AppColors.darkAccent
                          : Colors.grey.withOpacity(0.4),
                      width: hasImage ? 2 : 1,
                    ),
                  ),
                  child: hasImage
                      ? Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(
                          File(controller.selectedImagePath.value),
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (!isExpired)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: controller.removeImage,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close,
                                  color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                    ],
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isExpired
                              ? Colors.grey[300]
                              : AppColors.darkAccent.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.cloud_upload_rounded,
                          size: 30,
                          color: isExpired ? Colors.grey[600] : AppColors.darkAccent,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isExpired ? 'Waktu Unggah Telah Habis' : 'Klik untuk unggah screenshot',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: isExpired ? Colors.grey[600] : Colors.black87),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Atau pilih file dari galeri Anda',
                        style: TextStyle(
                            color: Colors.grey[500], fontSize: 11),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.verified_user_outlined,
                    size: 14, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text(
                  'Pastikan nominal dan nomor tujuan sesuai.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),

      // ==========================================
      // 5. TOMBOL SUBMIT (DISABLED IF EXPIRED)
      // ==========================================
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        color: AppColors.background,
        child: SizedBox(
          width: double.infinity,
          child: Obx(() {
            final isUploading = controller.isUploading.value;
            final isExpired = controller.isExpired.value;
            final isEnabled = !isUploading && !isExpired;

            return ElevatedButton(
              onPressed: isEnabled ? controller.submitPaymentProof : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                isEnabled ? AppColors.darkAccent : Colors.grey[400],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: isUploading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send, color: isEnabled ? Colors.white : Colors.grey[200], size: 18),
                  const SizedBox(width: 8),
                  Text(
                    isExpired ? 'Pembayaran Kadaluwarsa' : 'Kirim Bukti Pembayaran',
                    style: TextStyle(
                        color: isEnabled ? Colors.white : Colors.grey[200],
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}