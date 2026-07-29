// Lokasi: lib/app/modules/order/views/order_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/order_controller.dart';

class OrderView extends GetView<OrderController> {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OrderController());
    final currencyFormatter =
    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==========================================
                // 1. HEADER TYPE SWITCHER (ANTAR / AMBIL & LOKASI)
                // ==========================================
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE2F0D9),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Color(0xFFD97706), size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                controller.orderType.value == 'Antar'
                                    ? 'ALAMAT PENGIRIMAN'
                                    : 'LOKASI AMBIL',
                                style: const TextStyle(
                                    fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                controller.userAddress.value.isNotEmpty
                                    ? controller.userAddress.value
                                    : 'Alamat belum diatur',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          )),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Obx(() => Row(
                            children: [
                              _buildTypeToggleButton('Antar', controller.orderType.value == 'Antar'),
                              _buildTypeToggleButton('Ambil', controller.orderType.value == 'Ambil'),
                            ],
                          )),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ==========================================
                // 2. DROPDOWN CATEGORY & INTERACTIVE SEARCH ICON
                // ==========================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      // Dropdown Kategori Filter
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Obx(() => DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: controller.selectedCategory.value,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: controller.categories.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              if (newValue != null) {
                                // Panggil method controller agar filter diproses
                                controller.filterByCategory(newValue);
                              }
                            },
                          ),
                        )),
                      ),
                      const Spacer(),

                      // LOGIC TOMBOL ICON SEARCH
                      Obx(() {
                        final isOpen = controller.isSearchOpen.value;
                        return Container(
                          decoration: BoxDecoration(
                            color: isOpen ? const Color(0xFF007A4B) : Colors.white,
                            border: Border.all(
                              color: isOpen ? const Color(0xFF007A4B) : Colors.grey[300]!,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: Icon(
                              isOpen ? Icons.close : Icons.search,
                              size: 20,
                              color: isOpen ? Colors.white : Colors.black87,
                            ),
                            onPressed: controller.toggleSearch,
                          ),
                        );
                      }),
                      const SizedBox(width: 8),

                      // Wishlist Button
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.favorite_border, size: 20, color: Colors.black87),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),

                // ==========================================
                // ANIMATED SEARCH INPUT FIELD
                // ==========================================
                Obx(() {
                  if (!controller.isSearchOpen.value) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: TextField(
                      autofocus: true,
                      // Sambungkan ke controller.searchProduct
                      onChanged: (val) => controller.searchProduct(val),
                      decoration: InputDecoration(
                        hintText: 'Cari menu Tumbas Kopi...',
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF007A4B), size: 20),
                        suffixIcon: controller.searchQuery.value.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                          onPressed: () => controller.searchProduct(''),
                        )
                            : null,
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // Section Title Kategori
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Obx(() => Text(
                    controller.selectedCategory.value,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
                ),

                const SizedBox(height: 8),

                // ==========================================
                // 3. PRODUCT LIST ITEM (VERTIKAL ALA POINT COFFEE)
                // ==========================================
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(color: Color(0xFF007A4B)),
                      );
                    }

                    final products = controller.filteredProducts;
                    if (products.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                            const SizedBox(height: 8),
                            Text(
                              controller.searchQuery.value.isNotEmpty
                                  ? 'Menu "${controller.searchQuery.value}" tidak ditemukan'
                                  : 'Menu belum tersedia',
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final item = products[index];
                        return _buildPointCoffeeProductTile(context, item, currencyFormatter);
                      },
                    );
                  }),
                ),
              ],
            ),

            // ==========================================
            // 4. FLOATING CART SUMMARY BAR
            // ==========================================
            Obx(() {
              if (controller.totalCartItems == 0) return const SizedBox.shrink();
              return Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF007A4B),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${controller.totalCartItems} Item',
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Text(
                            currencyFormatter.format(controller.totalCartPrice),
                            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 11),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: controller.goToCheckout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: Row(
                          children: const [
                            Text('Lanjut Checkout',
                                style: TextStyle(
                                    color: Color(0xFF007A4B),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward, color: Color(0xFF007A4B), size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // Widget Button Switcher Antar / Ambil
  Widget _buildTypeToggleButton(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.setOrderType(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF007A4B) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // Helper untuk mengekstrak URL gambar secara aman dari key 'image_url' atau 'image'
  String _getImageUrl(Map<String, dynamic> item) {
    final url = item['image_url'] ?? item['image'];
    return (url is String && url.isNotEmpty) ? url : '';
  }

  // Widget Item Produk
  Widget _buildPointCoffeeProductTile(
      BuildContext context, Map<String, dynamic> item, NumberFormat currencyFormatter) {
    final imageUrl = _getImageUrl(item);
    final String name = item['name']?.toString() ?? 'Nama Produk';
    final num priceNum = (item['price'] is num) ? (item['price'] as num) : 0;
    final num? originalPriceNum = (item['originalPrice'] is num) ? (item['originalPrice'] as num) : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageUrl.isNotEmpty
                ? Image.network(
              imageUrl,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) => _buildImagePlaceholder(),
            )
                : _buildImagePlaceholder(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.electric_bolt, color: Colors.white, size: 12),
                      const SizedBox(width: 2),
                      Text(
                        item['badge']?.toString() ?? 'AMBIL SEKARANG',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      currencyFormatter.format(priceNum),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    if (originalPriceNum != null && originalPriceNum > priceNum) ...[
                      const SizedBox(width: 8),
                      Text(
                        currencyFormatter.format(originalPriceNum),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => _showProductDetail(context, item),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF007A4B),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 90,
      height: 90,
      color: Colors.grey[200],
      child: const Icon(Icons.local_cafe, color: Colors.grey),
    );
  }

  // Method Modal Detail Produk
  void _showProductDetail(BuildContext context, Map<String, dynamic> item) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    controller.openProductDetail(item);

    final imageUrl = _getImageUrl(item);
    final String name = item['name']?.toString() ?? 'Nama Produk';
    final String description = item['description']?.toString() ?? 'Tidak ada deskripsi produk.';
    final int price = (item['price'] is num) ? (item['price'] as num).toInt() : 0;

    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.88,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          imageUrl.isNotEmpty
                              ? Image.network(
                            imageUrl,
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Container(
                              height: 250,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: const Icon(Icons.local_cafe, size: 48, color: Colors.grey),
                            ),
                          )
                              : Container(
                            height: 250,
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: const Icon(Icons.local_cafe, size: 48, color: Colors.grey),
                          ),
                          Positioned(
                            right: 16,
                            top: 16,
                            child: GestureDetector(
                              onTap: () => Get.back(),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    name,
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  currencyFormatter.format(price),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF007A4B)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(description, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                            const SizedBox(height: 24),
                            const Text('TEMPERATURE',
                                style: TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                            const SizedBox(height: 12),
                            Obx(() => Row(
                              children: [
                                _buildOptionChip(
                                    'Hot',
                                    Icons.wb_sunny_outlined,
                                    controller.selectedTemperature.value == 'Hot',
                                        () => controller.selectedTemperature.value = 'Hot'),
                                const SizedBox(width: 12),
                                _buildOptionChip(
                                    'Ice',
                                    Icons.ac_unit,
                                    controller.selectedTemperature.value == 'Ice',
                                        () => controller.selectedTemperature.value = 'Ice'),
                              ],
                            )),
                            const SizedBox(height: 24),
                            const Text('SUGAR LEVEL',
                                style: TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                            const SizedBox(height: 12),
                            Obx(() => Row(
                              children: [
                                _buildOptionChip(
                                    'Normal',
                                    null,
                                    controller.selectedSugarLevel.value == 'Normal',
                                        () => controller.selectedSugarLevel.value = 'Normal'),
                                const SizedBox(width: 12),
                                _buildOptionChip(
                                    'Less',
                                    null,
                                    controller.selectedSugarLevel.value == 'Less',
                                        () => controller.selectedSugarLevel.value = 'Less'),
                              ],
                            )),
                            const SizedBox(height: 28),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                  color: Colors.grey[100], borderRadius: BorderRadius.circular(16)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Jumlah Pesanan',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: controller.decrementQuantity,
                                          icon: const Icon(Icons.remove, size: 18)),
                                      Obx(() => Text('${controller.quantity.value}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 16))),
                                      IconButton(
                                          onPressed: controller.incrementQuantity,
                                          icon: const Icon(Icons.add, size: 18),
                                          color: const Color(0xFF007A4B)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Obx(() {
                    final totalPrice = price * controller.quantity.value;
                    return ElevatedButton(
                      onPressed: () => controller.addToCartFromDetail(item),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007A4B),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tambah ke Keranjang',
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          Text(currencyFormatter.format(totalPrice),
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildOptionChip(String label, IconData? icon, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE2F0D9) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border:
          Border.all(color: isSelected ? const Color(0xFF007A4B) : Colors.transparent, width: 1.5),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: isSelected ? const Color(0xFF007A4B) : Colors.grey),
              const SizedBox(width: 6),
            ],
            Text(label,
                style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? const Color(0xFF007A4B) : Colors.grey[700],
                    fontSize: 13)),
          ],
        ),
      ),
    );
  }
}