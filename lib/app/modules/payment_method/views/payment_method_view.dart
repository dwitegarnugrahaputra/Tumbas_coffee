import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/payment_method_controller.dart';
import '../../../theme/app_colors.dart';

class PaymentMethodView extends GetView<PaymentMethodController> {
  const PaymentMethodView({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Metode Pembayaran',
          style: TextStyle(color: AppColors.darkAccent, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Total Bayar
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Bayar', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  const Text('Rp36.000', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkAccent)),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(),
                  ),
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Sudah termasuk pajak dan biaya layanan.',
                          style: TextStyle(color: Colors.grey[600], fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // E-Wallet Section
            Row(
              children: const [
                Icon(Icons.account_balance_wallet, size: 18, color: AppColors.darkAccent),
                SizedBox(width: 8),
                Text('E-Wallet', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkNeutral)),
              ],
            ),
            const SizedBox(height: 12),
            _buildPaymentOption('GoPay', Icons.account_balance_wallet, Colors.blue),
            _buildPaymentOption('OVO', Icons.account_balance_wallet, Colors.purple),
            _buildPaymentOption('Dana', Icons.account_balance_wallet, Colors.blueAccent),
            _buildPaymentOption('ShopeePay', Icons.account_balance_wallet, Colors.deepOrange),

            const SizedBox(height: 24),

            // Virtual Account Section (BARU)
            Row(
              children: const [
                Icon(Icons.account_balance, size: 18, color: AppColors.darkAccent),
                SizedBox(width: 8),
                Text('Virtual Account', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkNeutral)),
              ],
            ),
            const SizedBox(height: 12),
            _buildPaymentOption('BCA Virtual Account', Icons.account_balance, Colors.blue[800]!),
            _buildPaymentOption('Mandiri Virtual Account', Icons.account_balance, Colors.orange[700]!),
            _buildPaymentOption('BNI Virtual Account', Icons.account_balance, Colors.teal),
            _buildPaymentOption('BRI Virtual Account', Icons.account_balance, Colors.blue[600]!),

            const SizedBox(height: 24),

            // Instruksi Pembayaran (Dibungkus Obx biar dinamis)
            Obx(() {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.receipt_long, size: 18, color: AppColors.darkAccent),
                        SizedBox(width: 8),
                        Text('Instruksi Pembayaran', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                        'Silakan transfer ke ${controller.selectedMethod.value}:',
                        style: const TextStyle(fontSize: 12, color: Colors.grey)
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.virtualAccount,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1),
                          ),
                          GestureDetector(
                            onTap: controller.copyToClipboard,
                            child: const Icon(Icons.copy, color: AppColors.darkAccent, size: 20),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(child: Text('(a.n. Tumbas Kopi)', style: TextStyle(fontSize: 11, color: Colors.grey))),
                  ],
                ),
              );
            }),
            const SizedBox(height: 100),
          ],
        ),
      ),

      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        color: AppColors.background,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.goToConfirmation,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkAccent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Lanjut ke Pembayaran', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget helper
  Widget _buildPaymentOption(String title, IconData icon, Color iconColor) {
    return Obx(() {
      final isSelected = controller.selectedMethod.value == title;
      return GestureDetector(
        onTap: () => controller.setPaymentMethod(title),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.darkAccent : Colors.grey.withOpacity(0.2),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: isSelected ? AppColors.darkAccent : Colors.grey,
              ),
            ],
          ),
        ),
      );
    });
  }
}