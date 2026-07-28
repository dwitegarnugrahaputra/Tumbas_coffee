import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../routes/app_pages.dart';

class CheckoutController extends GetxController {
  var isLoadingLocation = false.obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var locationMessage = 'Tentukan lokasi pengiriman untuk memesan'.obs;

  final addressNoteCtrl = TextEditingController();
  final MapController mapController = MapController();
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

      // Cek apakah ini pengambilan lokasi pertama kali (saat peta belum dirender)
      bool isFirstTime = latitude.value == 0.0 && longitude.value == 0.0;

      // Update State Koordinat
      latitude.value = position.latitude;
      longitude.value = position.longitude;

      // Geser kamera peta HANYA JIKA peta sudah dirender (bukan klik pertama)
      if (!isFirstTime) {
        mapController.move(LatLng(position.latitude, position.longitude), 16.0);
      }

      // Reverse Geocoding untuk dapatkan teks alamat
      List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String fullAddress = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.postalCode}';

        locationMessage.value = fullAddress;
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
    // Arahkan ke halaman Metode Pembayaran
    Get.toNamed(Routes.PAYMENT_METHOD);
  }
}