import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

          // Tab Bar View (Isi konten per tab)
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                // 1. Tab Dalam Proses
                const Center(
                  child: Text('Belum ada pesanan dalam proses', style: TextStyle(color: Colors.grey)),
                ),

                // 2. Tab Selesai
                ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    _buildOrderCard(
                      date: '12 Okt 2023, 08:45',
                      inv: 'INV/20231012/TK/001',
                      title: 'Aren Latte Extra Shot',
                      desc: '1 Item • Less Sugar',
                      price: 'Rp 28.000',
                      imageUrl: 'https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=150',
                    ),
                    const SizedBox(height: 16),
                    _buildOrderCard(
                      date: '10 Okt 2023, 14:20',
                      inv: 'INV/20231010/TK/042',
                      title: 'Matcha Zen & Croissant',
                      desc: '2 Items • Regular Ice',
                      price: 'Rp 52.000',
                      imageUrl: 'https://images.unsplash.com/photo-1515823662972-da6a2e4d3002?q=80&w=150',
                    ),
                    const SizedBox(height: 16),
                    _buildBundleCard(), // Custom layout buat bundle yang banyak icon
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper buat Card Pesanan Standar
  Widget _buildOrderCard({
    required String date,
    required String inv,
    required String title,
    required String desc,
    required String price,
    required String imageUrl,
  }) {
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
                    Text(date, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    const SizedBox(height: 2),
                    Text(inv, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.darkNeutral)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: const [
                    Icon(Icons.check_circle_outline, color: AppColors.darkAccent, size: 14),
                    SizedBox(width: 4),
                    Text('Selesai', style: TextStyle(color: AppColors.darkAccent, fontSize: 11, fontWeight: FontWeight.bold)),
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
                child: Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(desc, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Total', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                  Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.darkAccent)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action Button
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: () => controller.viewInvoice(inv),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.darkAccent,
                side: const BorderSide(color: AppColors.darkAccent),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
              child: const Text('Lihat Bukti Transaksi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper Khusus buat layout Bundle (item ke-3 di gambar lu)
  Widget _buildBundleCard() {
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
                    Text('08 Okt 2023, 16:10', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    const SizedBox(height: 2),
                    const Text('INV/20231008/TK/089', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.darkNeutral)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: const [
                    Icon(Icons.check_circle_outline, color: AppColors.darkAccent, size: 14),
                    SizedBox(width: 4),
                    Text('Selesai', style: TextStyle(color: AppColors.darkAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()),

          const Text('Bundle Family: 4 Espresso', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text('4 Items • Package Deal', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 12),

          // Tumpukan Icon Bundle
          Row(
            children: [
              _buildMiniImage('https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?q=80&w=100'),
              const SizedBox(width: 4),
              _buildMiniImage('https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?q=80&w=100'),
              const SizedBox(width: 4),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.3), shape: BoxShape.circle),
                child: const Center(child: Text('+2', style: TextStyle(color: AppColors.darkAccent, fontSize: 11, fontWeight: FontWeight.bold))),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
              const Text('Rp 110.000', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.darkAccent)),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.darkAccent,
                side: const BorderSide(color: AppColors.darkAccent),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
              child: const Text('Lihat Bukti Transaksi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(url, width: 32, height: 32, fit: BoxFit.cover),
    );
  }
}