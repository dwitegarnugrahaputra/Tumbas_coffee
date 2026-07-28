// Lokasi: lib/app/modules/checkout/controllers/checkout_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// 1. TAMBAHKAN IMPORT ORDER CONTROLLER
import '../../order/controllers/order_controller.dart';
import '../../../routes/app_pages.dart';

class CheckoutController extends GetxController {
  var isLoadingLocation = false.obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var locationMessage = 'Tentukan lokasi pengiriman untuk memesan'.obs;

  final addressNoteCtrl = TextEditingController();
  final MapController mapController = MapController();
  final Geocoding geocoding = Geocoding();

  // Akses instance OrderController yang aktif di GetX
  OrderController get orderCtrl => Get.find<OrderController>();

  var deliveryFee = 0.obs;

  // Getter Ringkasan Cart
  List<Map<String, dynamic>> get cartItems => orderCtrl.cartItemsSummary;
  int get subtotalPrice => orderCtrl.totalCartPrice;
  int get grandTotalPrice => subtotalPrice + deliveryFee.value;

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

        // Null-safety check untuk string alamat
        List<String> addressParts = [
          if (place.street != null && place.street!.isNotEmpty) place.street!,
          if (place.subLocality != null && place.subLocality!.isNotEmpty) place.subLocality!,
          if (place.locality != null && place.locality!.isNotEmpty) place.locality!,
          if (place.subAdministrativeArea != null && place.subAdministrativeArea!.isNotEmpty) place.subAdministrativeArea!,
          if (place.postalCode != null && place.postalCode!.isNotEmpty) place.postalCode!,
        ];

        String fullAddress = addressParts.join(', ');

        locationMessage.value = fullAddress.isNotEmpty ? fullAddress : 'Lokasi Terdeteksi';
        addressNoteCtrl.text = locationMessage.value;
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

    if (cartItems.isEmpty) {
      Get.snackbar(
        'Keranjang Kosong',
        'Tidak ada item dalam keranjang pesanan.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    // Arahkan ke halaman Metode Pembayaran sambil membawa payload data checkout
    Get.toNamed(Routes.PAYMENT_METHOD, arguments: {
      'latitude': latitude.value,
      'longitude': longitude.value,
      'address': locationMessage.value,
      'address_note': addressNoteCtrl.text,
      'subtotal': subtotalPrice,
      'delivery_fee': deliveryFee.value,
      'total': grandTotalPrice,
      'items': cartItems,
    });
  }
}