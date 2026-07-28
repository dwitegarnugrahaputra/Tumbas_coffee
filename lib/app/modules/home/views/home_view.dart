// Lokasi: lib/app/modules/home/views/home_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../theme/app_colors.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Greeting & Profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                        'Halo, ${controller.userName.value}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkNeutral,
                        ),
                      )),
                      const Text(
                        'Mau ngopi apa hari ini?',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.notifications_none, color: AppColors.darkNeutral),
                      const SizedBox(width: 12),
                      const CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=200'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Location Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('LOKASI SAAT INI', style: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
                          Obx(() => Text(
                            controller.userLocation.value,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.darkNeutral),
                            overflow: TextOverflow.ellipsis,
                          )),
                        ],
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- AUTO SLIDER HERO BANNER ---
              SizedBox(
                height: 140,
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: controller.banners.length,
                  itemBuilder: (context, index) {
                    final banner = controller.banners[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(banner['image']!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 180,
                              child: Text(
                                banner['title']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              banner['subtitle']!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              // --- DOTS INDICATOR SLIDER ---
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.banners.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: controller.currentBannerIndex.value == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: controller.currentBannerIndex.value == index
                          ? AppColors.darkAccent
                          : Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              )),

              const SizedBox(height: 24),

              // Categories
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCategoryItem(0, Icons.local_cafe, 'Espresso'),
                  _buildCategoryItem(1, Icons.local_bar, 'Non-Coffee'),
                  _buildCategoryItem(2, Icons.bakery_dining, 'Pastry'),
                  _buildCategoryItem(3, Icons.grass, 'Beans'),
                ],
              ),
              const SizedBox(height: 24),

              // Section Best Seller (Sekarang Dinamis Berdasarkan Filter Kategori)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Paling Laris', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkNeutral)),
                  GestureDetector(
                    onTap: () => Get.toNamed('/order'),
                    child: const Text('Lihat Semua', style: TextStyle(fontSize: 12, color: AppColors.secondary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                // Menggunakan Obx agar list Paling Laris ter-update sesuai kategori yang diklik
                child: Obx(() {
                  if (controller.filteredProducts.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text('Belum ada menu di kategori ini 😅', style: TextStyle(color: Colors.grey)),
                    );
                  }

                  return Row(
                    children: controller.filteredProducts.map((product) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: _buildProductCard(
                          product['name'],
                          product['price'],
                          product['image'],
                        ),
                      );
                    }).toList(),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // Recommendation
              const Text('Rekomendasi Untukmu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkNeutral)),
              const SizedBox(height: 12),

              InkWell(
                onTap: () => controller.goToOrderPage({
                  'name': 'Matcha Creamy Oat',
                  'price': 'Rp25.000',
                  'image': 'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?q=80&w=300',
                }),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?q=80&w=300',
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('NEW RELEASE', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.darkAccent)),
                            ),
                            const SizedBox(height: 4),
                            const Text('Matcha Creamy Oat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 2),
                            const Text('Rich matcha with silky oat milk.', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            const SizedBox(height: 6),
                            const Text('Rp25.000', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.darkAccent)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(int index, IconData icon, String label) {
    return Obx(() {
      final isSelected = controller.selectedCategory.value == index;
      return GestureDetector(
        onTap: () => controller.selectCategory(index),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  if (!isSelected)
                    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 3)),
                ],
              ),
              child: Icon(icon, color: isSelected ? Colors.white : AppColors.darkNeutral),
            ),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      );
    });
  }

  // Card Produk Paling Laris (Clickable tanpa tombol tambah)
  Widget _buildProductCard(String name, String price, String imageUrl) {
    return InkWell(
      onTap: () => controller.goToOrderPage({
        'name': name,
        'price': price,
        'image': imageUrl,
      }),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                // --- ERROR BUILDER DITAMBAHKAN DI SINI ---
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.broken_image_rounded, color: Colors.grey, size: 30),
                        SizedBox(height: 4),
                        Text('Image failed', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  );
                },
                // -----------------------------------------
              ),
            ),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(price, style: const TextStyle(fontSize: 12, color: AppColors.darkAccent, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}