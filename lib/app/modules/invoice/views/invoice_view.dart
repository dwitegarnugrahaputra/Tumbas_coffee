// Lokasi: lib/app/modules/invoice/views/invoice_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/invoice_controller.dart';
import '../../../theme/app_colors.dart';

class InvoiceView extends GetView<InvoiceController> {
  const InvoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(InvoiceController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Header Success Icon & Teks
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, color: Colors.green, size: 48),
              ),
              const SizedBox(height: 20),
              const Text(
                'Pembayaran Berhasil!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkNeutral,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pesanan kamu berhasil dibuat.',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),

              // 2. Card Setruk / Invoice (DIBUNGKUS REPAINTBOUNDARY)
              RepaintBoundary(
                key: controller.invoiceKey, // Key untuk penangkapan gambar
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Bagian Informasi Transaksi ---
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('ID TRANSAKSI', style: TextStyle(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'TMB-20231024-0092',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Tanggal & Waktu', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                const Text('24 Okt 2023, 14:20 WIB', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(color: Colors.grey[100], thickness: 2, height: 0),

                      // --- Bagian Data Pelanggan ---
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nama Pelanggan', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                                const SizedBox(height: 4),
                                const Text('Tegar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkNeutral)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Lokasi Pengiriman', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                                const SizedBox(height: 4),
                                const Text(
                                  '-6.2088° S, 106.8456° E',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'monospace'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Efek sobekan kertas (Dashed Divider)
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: _DashedDivider(height: 1.0, color: Colors.grey),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 12,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
                                ),
                              ),
                              Container(
                                width: 12,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // --- Bagian Rincian Pesanan ---
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('DETAIL PESANAN', style: TextStyle(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                            const SizedBox(height: 16),

                            // Item 1
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network('https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=150', width: 40, height: 40, fit: BoxFit.cover),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Kopi Susu Tumbas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                      const SizedBox(height: 2),
                                      Text('2x', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                                    ],
                                  ),
                                ),
                                const Text('Rp36.000', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Item 2
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network('https://images.unsplash.com/photo-1515823662972-da6a2e4d3002?q=80&w=150', width: 40, height: 40, fit: BoxFit.cover),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Matcha Garden Latte', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                      const SizedBox(height: 2),
                                      Text('1x', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                                    ],
                                  ),
                                ),
                                const Text('Rp24.000', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Hitungan Biaya
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Subtotal', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                const Text('Rp60.000', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Biaya Layanan', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                const Text('Rp2.000', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Divider(color: Colors.grey[200]),
                            const SizedBox(height: 16),

                            // Total
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Total Bayar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.darkNeutral)),
                                Text('Rp62.000', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.darkAccent)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // 3. Action Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.backToHome,
                  icon: const Icon(Icons.home_outlined, color: Colors.white, size: 20),
                  label: const Text('Kembali ke Beranda', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tombol Simpan Bukti Transaksi Interaktif
              SizedBox(
                width: double.infinity,
                child: Obx(() => TextButton.icon(
                  onPressed: controller.isSaving.value ? null : controller.saveInvoice,
                  icon: controller.isSaving.value
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.darkAccent),
                  )
                      : const Icon(Icons.download, color: AppColors.darkAccent, size: 20),
                  label: Text(
                    controller.isSaving.value ? 'Menyimpan...' : 'Simpan Bukti Transaksi',
                    style: const TextStyle(color: AppColors.darkAccent, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                )),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  final double height;
  final Color color;

  const _DashedDivider({this.height = 1, this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color.withOpacity(0.3)),
              ),
            );
          }),
        );
      },
    );
  }
}