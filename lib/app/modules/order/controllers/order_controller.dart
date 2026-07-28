// Lokasi: lib/app/modules/order/controllers/order_controller.dart

import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../routes/app_pages.dart';

class OrderController extends GetxController {
  // 1. Order Type State ('Antar' atau 'Ambil')
  var orderType = 'Antar'.obs;
  var userAddress = 'Mencari lokasi...'.obs;

  // 2. Filter Kategori
  var selectedCategory = 'Signature Series'.obs;
  final categories = ['Signature Series', 'Espresso', 'Non-Coffee', 'Pastry'];

  // 3. LOGIC & STATE PENCARIAN (SEARCH)
  var isSearchOpen = false.obs; // Toggle visibilitas search bar
  var searchQuery = ''.obs;      // Keyword pencarian

  // Cart State (Simpan jumlah per ID produk)
  var cartItems = <String, int>{}.obs;

  // State untuk Detail Product BottomSheet
  var selectedTemperature = 'Ice'.obs;
  var selectedSugarLevel = 'Normal'.obs;
  var quantity = 1.obs;

  // Dummy List Produk
  final products = [
    {
      'id': '1',
      'name': 'Iced Oat Aren Latte',
      'category': 'Signature Series',
      'price': 25000,
      'originalPrice': 25000,
      'badge': 'AMBIL SEKARANG',
      'description': 'Kopi susu gula aren khas Tumbas dengan racikan oat milk nikmat.',
      'image': 'https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=400',
    },
    {
      'id': '2',
      'name': 'Iced Markisa Apelkano',
      'category': 'Signature Series',
      'price': 20000,
      'originalPrice': 25000,
      'badge': 'AMBIL SEKARANG',
      'description': 'Paduan espresso segar dengan rasa manis markisa dan apel.',
      'image': 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?q=80&w=400',
    },
    {
      'id': '3',
      'name': 'Iced Peach Jerukano',
      'category': 'Signature Series',
      'price': 20000,
      'originalPrice': 25000,
      'badge': 'AMBIL SEKARANG',
      'description': 'Espresso dingin dipadu rasa buah peach dan bulir jeruk segar.',
      'image': 'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?q=80&w=400',
    },
    {
      'id': '4',
      'name': 'Iced Lychee Berrikano',
      'category': 'Signature Series',
      'price': 20000,
      'originalPrice': 25000,
      'badge': 'AMBIL SEKARANG',
      'description': 'Espresso dingin dengan kesegaran rasa buah leci dan berri.',
      'image': 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?q=80&w=400',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  // Toggle Buka / Tutup Search Bar
  void toggleSearch() {
    isSearchOpen.value = !isSearchOpen.value;
    if (!isSearchOpen.value) {
      searchQuery.value = ''; // Clear keyword kalau search bar ditutup
    }
  }

  // --- FUNGSI GPS SINKRON DENGAN MAPS ---
  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        userAddress.value = 'GPS HP belum dinyalakan';
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          userAddress.value = 'Izin lokasi ditolak';
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        userAddress.value = 'Izin lokasi diblokir';
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final Geocoding geocode = Geocoding();
      List<Placemark> placemarks = await geocode.placemarkFromCoordinates(
          position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String street = place.street ?? '';
        String locality = place.locality ?? '';

        String address = '$street, $locality'.replaceAll(RegExp(r'^, |,$'), '');
        userAddress.value = address;
      }
    } catch (e) {
      userAddress.value = 'Gagal memuat lokasi';
    }
  }

  void setOrderType(String type) {
    orderType.value = type;
  }

  // Getter List Produk terfilter (Berdasarkan Kategori & Kata Kunci Search)
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

  void addToCartFromDetail(String productId) {
    final currentQty = cartItems[productId] ?? 0;
    cartItems[productId] = currentQty + quantity.value;
    Get.back();
  }

  // ===== METHOD KERANJANG UMUM =====
  void addToCart(String productId) {
    if (cartItems.containsKey(productId)) {
      cartItems[productId] = cartItems[productId]! + 1;
    } else {
      cartItems[productId] = 1;
    }
  }

  int get totalCartItems {
    int total = 0;
    cartItems.forEach((key, value) {
      total += value;
    });
    return total;
  }

  int get totalCartPrice {
    int total = 0;
    cartItems.forEach((productId, qty) {
      final product = products.firstWhere((p) => p['id'] == productId);
      total += (product['price'] as int) * qty;
    });
    return total;
  }

  void goToCheckout() {
    Get.toNamed(Routes.CHECKOUT);
  }
}