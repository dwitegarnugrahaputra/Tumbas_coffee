// Lokasi: lib/app/modules/home/controllers/home_controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomeController extends GetxController {
  // ==========================================
  // 1. VARIABEL UNTUK AUTO SLIDER BANNER
  // ==========================================
  final PageController pageController = PageController();
  var currentBannerIndex = 0.obs;
  Timer? _timer;

  final List<Map<String, String>> banners = [
    {
      'image': 'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?q=80&w=800',
      'title': 'Promo Spesial Kopi Susu',
      'subtitle': 'Diskon 20% khusus hari ini aja!',
    },
    {
      'image': 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?q=80&w=800',
      'title': 'Suasana Baru, Inspirasi Baru',
      'subtitle': 'Nongkrong asik sambil nugas.',
    },
    {
      'image': 'https://images.unsplash.com/photo-1445116572660-236099ec97a0?q=80&w=800',
      'title': 'Biji Kopi Pilihan',
      'subtitle': 'Nikmati racikan arabica terbaik.',
    },
  ];

  // ==========================================
  // 2. VARIABEL DATA BERANDA & FILTERING
  // ==========================================
  var userName = 'Tegar'.obs;
  var userLocation = 'Mencari lokasi...'.obs;
  var selectedCategory = 0.obs;

  // Master Data Produk (Dummy Database)
  // categoryId -> 0: Espresso, 1: Non-Coffee, 2: Pastry, 3: Beans
  final List<Map<String, dynamic>> allProducts = [
    // Kategori 0: Espresso
    {'name': 'Kopi Susu Tumbas', 'price': 'Rp18.000', 'image': 'https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=300', 'categoryId': 0},
    {'name': 'Americano Warmth', 'price': 'Rp15.000', 'image': 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?q=80&w=300', 'categoryId': 0},
    {'name': 'Caramel Macchiato', 'price': 'Rp22.000', 'image': 'https://images.unsplash.com/photo-1485808191679-5f86510681a2?q=80&w=300', 'categoryId': 0},

    // Kategori 1: Non-Coffee
    {'name': 'Matcha Creamy Oat', 'price': 'Rp25.000', 'image': 'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?q=80&w=300', 'categoryId': 1},
    // LINK TARO LATTE DIPERBARUI
    {'name': 'Taro Latte', 'price': 'Rp20.000', 'image': 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?q=80&w=300', 'categoryId': 1},

    // Kategori 2: Pastry
    // LINK BUTTER CROISSANT DIPERBARUI
    {'name': 'Butter Croissant', 'price': 'Rp15.000', 'image': 'https://images.unsplash.com/photo-1549996647-190b679b33d7?q=80&w=300', 'categoryId': 2},
    {'name': 'Pain au Chocolat', 'price': 'Rp18.000', 'image': 'https://images.unsplash.com/photo-1608198093002-ad4e005484ec?q=80&w=300', 'categoryId': 2},

    // Kategori 3: Beans
    {'name': 'Arabica Blend 200g', 'price': 'Rp75.000', 'image': 'https://images.unsplash.com/photo-1559525839-b184a4d698c7?q=80&w=300', 'categoryId': 3},
    {'name': 'Robusta Beans 200g', 'price': 'Rp50.000', 'image': 'https://images.unsplash.com/photo-1611162458324-aae1eb4129a4?q=80&w=300', 'categoryId': 3},
  ];

  // Logic filter produk berdasarkan kategori yang dipilih
  List<Map<String, dynamic>> get filteredProducts {
    return allProducts.where((product) => product['categoryId'] == selectedCategory.value).toList();
  }

  @override
  void onInit() {
    super.onInit();
    startAutoSlide();
    getCurrentLocation();
  }

  // ==========================================
  // 3. FUNGSI NAVIGASI
  // ==========================================
  void goToOrderPage(Map<String, dynamic> product) {
    Get.toNamed('/order', arguments: product);
  }

  // --- Fungsi Slider ---
  void startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (pageController.hasClients) {
        int nextPage = currentBannerIndex.value + 1;
        if (nextPage >= banners.length) {
          nextPage = 0;
        }
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void onPageChanged(int index) {
    currentBannerIndex.value = index;
  }

  // --- Fungsi Kategori ---
  void selectCategory(int index) {
    selectedCategory.value = index;
  }

  // --- FUNGSI GPS ---
  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        userLocation.value = 'GPS HP belum dinyalakan';
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          userLocation.value = 'Izin lokasi ditolak';
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        userLocation.value = 'Izin lokasi diblokir permanen';
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
        userLocation.value = address;
      }
    } catch (e) {
      userLocation.value = 'Gagal memuat lokasi';
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}