// Lokasi: lib/app/modules/history/views/history_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/history_controller.dart';
import '../../../theme/app_colors.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HistoryController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.darkNeutral),
          onPressed: () {},
        ),
        title: const Text(
          'Tumbas Kopi',
          style: TextStyle(
            color: AppColors.darkAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.darkNeutral),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Teks
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Riwayat Pesanan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkNeutral),
                ),
                const SizedBox(height: 4),
                Text(
                  'Lacak dan lihat semua pesanan kopi Anda di sini.',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1)),
            ),
            child: TabBar(
              controller: controller.tabController,
              labelColor: AppColors.darkAccent,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: AppColors.darkAccent,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              tabs: const [
                Tab(text: 'Dalam Proses'),
                Tab(text: 'Selesai'),
              ],
            ),
          ),

          // Tab Bar View (Isi konten per tab Dinamis)
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: AppColors.darkAccent));
              }

              return TabBarView(
                controller: controller.tabController,
                children: [
                  // 1. Tab Dalam Proses
                  controller.onProcessOrders.isEmpty
                      ? const Center(child: Text('Belum ada pesanan dalam proses', style: TextStyle(color: Colors.grey)))
                      : ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemCount: controller.onProcessOrders.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return _buildDynamicOrderCard(controller.onProcessOrders[index]);
                    },
                  ),

                  // 2. Tab Selesai
                  controller.completedOrders.isEmpty
                      ? const Center(child: Text('Belum ada riwayat pesanan', style: TextStyle(color: Colors.grey)))
                      : ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemCount: controller.completedOrders.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return _buildDynamicOrderCard(controller.completedOrders[index]);
                    },
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // Widget Helper Buat Render Card Dinamis
  Widget _buildDynamicOrderCard(Map<String, dynamic> order) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    // Format Tanggal
    String formattedDate = '-';
    if (order['created_at'] != null) {
      formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(order['created_at']).toLocal());
    }

    // Ambil detail items
    final List<dynamic> items = order['order_items'] ?? [];
    String title = 'Pesanan Tumbas';
    int totalQty = 0;

    if (items.isNotEmpty) {
      title = items[0]['product_name'] ?? 'Produk Kopi';
      if (items.length > 1) {
        title += ' & ${items.length - 1} item lainnya';
      }
      for (var item in items) {
        totalQty += (item['quantity'] as int? ?? 1);
      }
    }

    final totalPrice = currencyFormatter.format(order['total_price'] ?? 0);
    final status = order['status'] ?? 'UNKNOWN';

    // Setel warna status (AMAT DARI NULL CHECK OPERATOR EXCEPTION)
    Color statusBgColor = Colors.grey.shade200;
    Color statusTextColor = Colors.grey.shade700;
    IconData statusIcon = Icons.info_outline;
    String statusText = status;

    if (status == 'WAITING_VERIFICATION') {
      statusBgColor = Colors.orange.withOpacity(0.2);
      statusTextColor = Colors.orange.shade800;
      statusIcon = Icons.hourglass_empty;
      statusText = 'Verifikasi';
    } else if (status == 'CANCELED' || status == 'EXPIRED') {
      statusBgColor = Colors.red.withOpacity(0.2);
      statusTextColor = Colors.red.shade800;
      statusIcon = Icons.cancel_outlined;
    } else if (status == 'COMPLETED') {
      statusBgColor = Colors.green.withOpacity(0.2);
      statusTextColor = AppColors.darkAccent;
      statusIcon = Icons.check_circle_outline;
      statusText = 'Selesai';
    } else {
      statusBgColor = Colors.green.withOpacity(0.2);
      statusTextColor = AppColors.darkAccent;
      statusIcon = Icons.check_circle_outline;
    }

    // Placeholder image
    const String placeholderImg = 'https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=150';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card (Icon, Date, Status)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), shape: BoxShape.circle),
                child: const Icon(Icons.receipt_long, color: AppColors.darkAccent, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(formattedDate, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    const SizedBox(height: 2),
                    Text(
                        'TRX-${order['id'].toString().substring(0, 8).toUpperCase()}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.darkNeutral)
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Icon(statusIcon, color: statusTextColor, size: 14),
                    const SizedBox(width: 4),
                    Text(statusText, style: TextStyle(color: statusTextColor, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()),

          // Body Card (Image, Title, Price)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(placeholderImg, width: 50, height: 50, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text('$totalQty Items', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Total', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                  Text(totalPrice, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.darkAccent)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action Button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Tombol Simulasi (Hanya muncul kalau statusnya BUKAN Selesai/Batal)
              if (status != 'COMPLETED' && status != 'CANCELED' && status != 'EXPIRED')
                ElevatedButton(
                  onPressed: () => controller.completeOrder(order['id']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007A4B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    elevation: 0,
                  ),
                  child: const Text('Terima Pesanan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                ),

              if (status != 'COMPLETED' && status != 'CANCELED' && status != 'EXPIRED')
                const SizedBox(width: 8),

              // Tombol Detail / Invoice bawaan
              OutlinedButton(
                onPressed: () => controller.viewInvoice(order['id']),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.darkAccent,
                  side: const BorderSide(color: AppColors.darkAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
                child: const Text('Detail / Invoice', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}