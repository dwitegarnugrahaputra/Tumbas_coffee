import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/payment_confirmation_controller.dart';
import '../../../theme/app_colors.dart';

class PaymentConfirmationView extends GetView<PaymentConfirmationController> {
  const PaymentConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
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
          style: TextStyle(color: AppColors.darkAccent, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 1. Alert Info
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
                      style: TextStyle(color: Colors.green[800], fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Card Ringkasan Singkat
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ID Pesanan', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      const Text('TMB-20231024-0092', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Pembayaran', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      const Text('Rp36.000', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.darkAccent)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Upload Area (Paling Penting)
            Obx(() {
              final hasImage = controller.selectedImagePath.value.isNotEmpty;

              return GestureDetector(
                onTap: controller.pickImage,
                child: Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: hasImage ? AppColors.darkAccent : Colors.grey.withOpacity(0.5),
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
                            child: const Icon(Icons.close, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.darkAccent.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.cloud_upload_rounded, size: 32, color: AppColors.darkAccent),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Klik untuk unggah screenshot',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Atau pilih file dari galeri Anda',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),

            // Note kecil di bawah upload
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.verified_user_outlined, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text('Pastikan nominal dan nomor tujuan sesuai.', style: TextStyle(color: Colors.grey[600], fontSize: 11)),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),

      // 4. Tombol Kirim Bukti
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        color: AppColors.background,
        child: SizedBox(
          width: double.infinity,
          child: Obx(() {
            final isEnabled = controller.selectedImagePath.value.isNotEmpty && !controller.isUploading.value;

            return ElevatedButton(
              onPressed: isEnabled ? controller.submitPaymentProof : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isEnabled ? AppColors.darkAccent : Colors.grey[300],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: controller.isUploading.value
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send, color: isEnabled ? Colors.white : Colors.grey[500], size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Kirim Bukti Pembayaran',
                    style: TextStyle(color: isEnabled ? Colors.white : Colors.grey[500], fontWeight: FontWeight.bold, fontSize: 14),
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