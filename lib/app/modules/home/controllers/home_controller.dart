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
  // 2. VARIABEL UNTUK DATA BERANDA
  // ==========================================
  var userName = 'Tegar'.obs;
  var userLocation = 'Mencari lokasi...'.obs;
  var selectedCategory = 0.obs;

  @override
  void onInit() {
    super.onInit();
    startAutoSlide();

    // PEMANGGILAN FUNGSI GPS
    getCurrentLocation();
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

  // --- FUNGSI UTAMA GPS (VERSI GEOCODING TERBARU v5.0+) ---
  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      // 1. Cek apakah fitur GPS di HP nyala
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        userLocation.value = 'GPS HP belum dinyalakan';
        return;
      }

      // 2. Cek apakah app udah dikasih izin lokasi
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

      // 3. Ambil titik koordinat (Latitude & Longitude)
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // 4. Ubah koordinat jadi nama jalan pakai Geocoding VERSI 5.0.0 KE ATAS
      // Wajib bikin instancenya (objek) dulu seperti ini:
      final Geocoding geocode = Geocoding();

      // Baru dipanggil melalui objeknya
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