// Lokasi: lib/app/modules/order/controllers/order_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../main.dart'; // Import global client 'supabase'
import '../../../routes/app_pages.dart';

class OrderController extends GetxController {
  // State Reactive Katalog Produk
  var allProducts = <Map<String, dynamic>>[].obs;
  var filteredProducts = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  // Search, Filter & Location
  var selectedCategory = 'Semua'.obs;
  var searchQuery = ''.obs;
  var isSearchOpen = false.obs;
  var userAddress = 'Jl. Narasoma, Purbalingga Wetan, Purbalingga'.obs; // <-- Penambahan Variabel

  // List Kategori untuk Tab UI
  final List<String> categories = [
    'Semua',
    'Espresso',
    'Non-Coffee',
    'Pastry',
    'Beans'
  ];

  // Order Type (Dine In / Take Away)
  var orderType = 'Dine In'.obs;

  // Detail Modal BottomSheet State
  var selectedProductForDetail = <String, dynamic>{}.obs;
  var selectedTemperature = 'Ice'.obs;
  var selectedSugarLevel = 'Normal Sugar'.obs;
  var quantity = 1.obs;

  // Keranjang Belanja (Key: product_id, Value: quantity)
  var cart = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProductsFromSupabase();
  }

  // 1. FETCH DATA PRODUK DARI SUPABASE (FR-BE-03)
  Future<void> fetchProductsFromSupabase() async {
    try {
      isLoading.value = true;

      final List<dynamic> response = await supabase
          .from('products')
          .select()
          .eq('is_available', true)
          .order('name', ascending: true);

      allProducts.value = List<Map<String, dynamic>>.from(response);
      applyFilterAndSearch();
    } catch (e) {
      Get.snackbar('Error Produk', 'Gagal memuat katalog menu: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle Tampilan Search Bar
  void toggleSearch() {
    isSearchOpen.value = !isSearchOpen.value;
    if (!isSearchOpen.value) {
      searchQuery.value = '';
      applyFilterAndSearch();
    }
  }

  // Set Order Type
  void setOrderType(String type) {
    orderType.value = type;
  }

  // Filter Kategori
  void filterByCategory(String category) {
    selectedCategory.value = category;
    applyFilterAndSearch();
  }

  // Search Product
  void searchProduct(String query) {
    searchQuery.value = query;
    applyFilterAndSearch();
  }

  void applyFilterAndSearch() {
    var result = allProducts.toList();

    // Filter Kategori
    if (selectedCategory.value != 'Semua') {
      result = result
          .where((p) =>
      p['category'].toString().toLowerCase() ==
          selectedCategory.value.toLowerCase())
          .toList();
    }

    // Filter Query Search
    if (searchQuery.value.isNotEmpty) {
      result = result
          .where((p) => p['name']
          .toString()
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    filteredProducts.value = result;
  }

  // 2. KERANJANG BELANJA & ALUR CUSTOM DETAIL
  void openProductDetail(Map<String, dynamic> product) {
    selectedProductForDetail.value = product;
    selectedTemperature.value = 'Ice';
    selectedSugarLevel.value = 'Normal Sugar';
    quantity.value = 1;
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  // <-- UPDATE: Tambah parameter opsional agar matching dengan View
  void addToCartFromDetail([Map<String, dynamic>? product]) {
    final targetProduct = (product != null && product.isNotEmpty)
        ? product
        : selectedProductForDetail;

    final String? productId = targetProduct['id'];

    if (productId == null) return;

    if (cart.containsKey(productId)) {
      cart[productId] = cart[productId]! + quantity.value;
    } else {
      cart[productId] = quantity.value;
    }

    if (Get.isBottomSheetOpen ?? false) {
      Get.back(); // Tutup BottomSheet Detail
    }

    Get.snackbar(
      'Ditambahkan',
      '${targetProduct['name'] ?? 'Produk'} berhasil ditambahkan ke keranjang!',
      backgroundColor: const Color(0xFF007A4B),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  void addToCart(String productId) {
    if (cart.containsKey(productId)) {
      cart[productId] = cart[productId]! + 1;
    } else {
      cart[productId] = 1;
    }
  }

  void removeFromCart(String productId) {
    if (cart.containsKey(productId)) {
      if (cart[productId]! > 1) {
        cart[productId] = cart[productId]! - 1;
      } else {
        cart.remove(productId);
      }
    }
  }

  int getQuantity(String productId) {
    return cart[productId] ?? 0;
  }

  int get totalCartItems {
    return cart.values.fold(0, (sum, item) => sum + item);
  }

  // Alias Getter Total Price untuk UI
  int get totalCartPrice {
    int total = 0;
    cart.forEach((productId, qty) {
      final product = allProducts.firstWhere(
            (p) => p['id'] == productId,
        orElse: () => {'price': 0},
      );
      final price = (product['price'] is num) ? (product['price'] as num).toInt() : 0;
      total += price * qty;
    });
    return total;
  }

  int get totalPrice => totalCartPrice;

  // Navigasi ke Checkout
  void goToCheckout() {
    if (cart.isEmpty) {
      Get.snackbar('Keranjang Kosong', 'Pilih minimal 1 menu sebelum checkout!');
      return;
    }
    Get.toNamed(Routes.CHECKOUT);
  }

  // Ringkasan Item Cart
  List<Map<String, dynamic>> get cartItemsSummary {
    List<Map<String, dynamic>> summary = [];
    cart.forEach((productId, qty) {
      final product = allProducts.firstWhere((p) => p['id'] == productId);
      summary.add({
        'product_id': productId,
        'name': product['name'],
        'price': product['price'],
        'quantity': qty,
        'image_url': product['image_url'],
      });
    });
    return summary;
  }
}