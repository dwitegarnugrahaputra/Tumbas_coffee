// Lokasi: lib/app/modules/payment_method/views/payment_method_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/payment_method_controller.dart';

class PaymentMethodView extends GetView<PaymentMethodController> {
  const PaymentMethodView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Pilih Metode Pembayaran',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF007A4B)),
                  );
                }

                if (controller.paymentMethods.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.payment_outlined, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        const Text(
                          'Metode pembayaran tidak tersedia',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  );
                }

                // Grouping berdasarkan kategori (misal: E-Wallet, Bank Transfer, dll)
                final methods = controller.paymentMethods;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: methods.length,
                  itemBuilder: (context, index) {
                    final method = methods[index];
                    return _buildPaymentTile(method);
                  },
                );
              }),
            ),

            // Tombol Konfirmasi Pembayaran
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2)),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.confirmSelection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007A4B),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Gunakan Metode Ini',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentTile(Map<String, dynamic> method) {
    final String name = method['name']?.toString() ?? 'Metode Pembayaran';
    final String category = method['category']?.toString() ?? 'Lainnya';
    final String? iconUrl = method['icon_url']?.toString();
    final String methodId = method['id']?.toString() ?? '';

    return Obx(() {
      final isSelected = controller.selectedPaymentMethod['id']?.toString() == methodId;

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF007A4B) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: ListTile(
          onTap: () => controller.selectPaymentMethod(method),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: (iconUrl != null && iconUrl.isNotEmpty)
                ? Image.network(
              iconUrl,
              fit: BoxFit.contain,
              errorBuilder: (ctx, err, stack) => const Icon(Icons.account_balance_wallet, color: Color(0xFF007A4B)),
            )
                : const Icon(Icons.account_balance_wallet, color: Color(0xFF007A4B)),
          ),
          title: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          subtitle: Text(
            category,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          trailing: Radio<String>(
            value: methodId,
            groupValue: controller.selectedPaymentMethod['id']?.toString(),
            activeColor: const Color(0xFF007A4B),
            onChanged: (val) => controller.selectPaymentMethod(method),
          ),
        ),
      );
    });
  }
}