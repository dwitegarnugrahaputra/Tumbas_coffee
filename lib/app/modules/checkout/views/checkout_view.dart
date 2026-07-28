import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/checkout_controller.dart';
import '../../../theme/app_colors.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CheckoutController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkAccent),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: AppColors.darkAccent,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Lokasi Pengiriman (Card Map ala Point Coffee)
            const Text(
              'Lokasi Pengiriman',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkNeutral),
            ),
            const SizedBox(height: 12),
            Container(
              height: 240, // Tinggi card map
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Obx(() {
                  final hasLocation = controller.latitude.value != 0.0 && controller.longitude.value != 0.0;
                  final userPosition = LatLng(controller.latitude.value, controller.longitude.value);

                  return Stack(
                    children: [
                      // Map View
                      if (hasLocation)
                        FlutterMap(
                          mapController: controller.mapController,
                          options: MapOptions(
                            initialCenter: userPosition,
                            initialZoom: 16.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.tumbaskopi.app',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: userPosition,
                                  width: 40,
                                  height: 40,
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.redAccent,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      else
                      // Tampilan placeholder sebelum Ambil Lokasi
                        Container(
                          color: Colors.grey[100],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.map_outlined, size: 48, color: Colors.grey[400]),
                                const SizedBox(height: 8),
                                Text(
                                  'Peta belum ditentukan',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Floating Badge Alamat (Ala Point Coffee)
                      if (hasLocation)
                        Positioned(
                          top: 12,
                          left: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.my_location, size: 16, color: AppColors.darkAccent),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Lokasimu',
                                        style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        controller.locationMessage.value,
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.darkNeutral),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Tombol Ambil / Update Lokasi
                      Positioned(
                        bottom: 12,
                        left: 12,
                        right: 12,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: controller.isLoadingLocation.value ? null : controller.getCurrentLocation,
                            icon: controller.isLoadingLocation.value
                                ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Icon(Icons.gps_fixed, size: 16, color: Colors.white),
                            label: Text(
                              hasLocation ? 'Update Lokasi Saya' : 'Ambil Lokasi Saya',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkAccent,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),

            // 2. Catatan Alamat
            const Text(
              'Catatan Alamat',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkNeutral),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: TextField(
                controller: controller.addressNoteCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Contoh: Rumah pagar hitam, sebelah warung Madura...',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                  filled: true,
                  fillColor: AppColors.background.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 3. Ringkasan Pesanan
            const Text(
              'Ringkasan Pesanan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkNeutral),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=200',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Kopi Susu Tumbas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text('2 x Rp18.000', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.sort, size: 14, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text('Less sugar, extra ice', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Text('Rp36.000', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 4. Rincian Pembayaran
            const Text(
              'Rincian Pembayaran',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkNeutral),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      const Text('Rp36.000', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Biaya Pengiriman', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      const Text('Gratis', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.secondary)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Total Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.darkNeutral)),
                      Text('Rp36.000', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.secondary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),

      // 5. Sticky Bottom CTA
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        color: AppColors.background,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.processOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkAccent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Pilih Metode Pembayaran', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}