import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class OrderController extends GetxController {
  // Filter Kategori
  var selectedCategory = 'Semua'.obs;
  final categories = ['Semua', 'Espresso', 'Non-Coffee', 'Pastry'];

  // Keyword Search
  var searchQuery = ''.obs;

  // Cart State (Simpan jumlah per ID produk)
  var cartItems = <String, int>{}.obs;

  // State untuk Detail Product BottomSheet
  var selectedTemperature = 'Ice'.obs;
  var selectedSugarLevel = 'Normal'.obs;
  var quantity = 1.obs;

  // Dummy List Produk (Sesuai DDL PRD)
  final products = [
    {
      'id': '1',
      'name': 'Kopi Susu Tumbas',
      'category': 'Espresso',
      'price': 18000,
      'description': 'Kopi susu gula aren khas Tumbas yang nikmat.',
      'image': 'https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=400',
    },
    {
      'id': '2',
      'name': 'Americano Warmth',
      'category': 'Espresso',
      'price': 15000,
      'description': 'Espresso murni dengan air panas pilihan.',
      'image': 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?q=80&w=400',
    },
    {
      'id': '3',
      'name': 'Matcha Garden Latte',
      'category': 'Non-Coffee',
      'price': 22000,
      'description': 'Teh hijau jepang premium dengan susu segar.',
      'image': 'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?q=80&w=400',
    },
    {
      'id': '4',
      'name': 'Croissant Butter',
      'category': 'Pastry',
      'price': 18000,
      'description': 'Pastry renyah dengan aroma mentega gurih.',
      'image': 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?q=80&w=400',
    },
  ];

  // Getter List Produk terfilter
  List<Map<String, dynamic>> get filteredProducts {
    return products.where((product) {
      final matchesCategory = selectedCategory.value == 'Semua' ||
          product['category'] == selectedCategory.value;
      final matchesSearch = product['name']
          .toString()
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  // ===== METHOD UNTUK BOTTOM SHEET DETAIL PRODUK =====

  // Method reset opsi saat modal dibuka
  void openProductDetail(Map<String, dynamic> product) {
    selectedTemperature.value = 'Ice';
    selectedSugarLevel.value = 'Normal';
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

  // Method tambah ke keranjang dari detail sheet
  void addToCartFromDetail(String productId) {
    final currentQty = cartItems[productId] ?? 0;
    cartItems[productId] = currentQty + quantity.value;
    Get.back(); // Tutup BottomSheet setelah ditambah ke keranjang
  }

  // ===== METHOD KERANJANG UMUM =====

  // Tambah item ke keranjang (dari tombol + Tambah cepat di grid)
  void addToCart(String productId) {
    if (cartItems.containsKey(productId)) {
      cartItems[productId] = cartItems[productId]! + 1;
    } else {
      cartItems[productId] = 1;
    }
  }

  // Hitung Total Item di Keranjang
  int get totalCartItems {
    int total = 0;
    cartItems.forEach((key, value) {
      total += value;
    });
    return total;
  }

  // Hitung Total Harga di Keranjang
  int get totalCartPrice {
    int total = 0;
    cartItems.forEach((productId, qty) {
      final product = products.firstWhere((p) => p['id'] == productId);
      total += (product['price'] as int) * qty;
    });
    return total;
  }

  // Navigasi ke Checkout
  void goToCheckout() {
    Get.toNamed(Routes.CHECKOUT);
  }
}