import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // Nggak perlu pakai alias lagi
import '../../../routes/app_pages.dart';

class CheckoutController extends GetxController {
  var isLoadingLocation = false.obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var locationMessage = 'Tentukan lokasi pengiriman untuk memesan'.obs;

  final addressNoteCtrl = TextEditingController();

  // INISIALISASI INSTANCE GEOCODING (WAJIB BUAT V5.0.0 KE ATAS)
  final Geocoding geocoding = Geocoding();

  @override
  void onClose() {
    addressNoteCtrl.dispose();
    super.onClose();
  }

  Future<void> getCurrentLocation() async {
    isLoadingLocation.value = true;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Perhatian', 'Layanan GPS di perangkat lu tidak aktif.');
        isLoadingLocation.value = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Perhatian', 'Izin akses lokasi ditolak.');
          isLoadingLocation.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar('Perhatian', 'Izin lokasi ditolak permanen. Buka pengaturan HP lu.');
        isLoadingLocation.value = false;
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      // CARA BARU DI V5.0.0: Panggil dari instance "geocoding."
      List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // Susun alamatnya
        String fullAddress = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.postalCode}';

        // Update UI tulisan lokasi
        locationMessage.value = fullAddress;

        // OTOMATIS ISI KOLOM CATATAN ALAMAT
        addressNoteCtrl.text = fullAddress;
      } else {
        locationMessage.value = 'Lat: ${position.latitude}, Long: ${position.longitude}';
      }

    } catch (e) {
      Get.snackbar('Error', 'Gagal mendapatkan lokasi: $e');
    } finally {
      isLoadingLocation.value = false;
    }
  }

  void processOrder() {
    if (latitude.value == 0.0 && longitude.value == 0.0) {
      Get.snackbar(
        'Lokasi Kosong',
        'Lu harus tap "Ambil Lokasi Saya" dulu sebelum checkout!',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    print("Memproses pesanan di koordinat: ${latitude.value}, ${longitude.value}");
    Get.toNamed(Routes.INVOICE);
  }
}