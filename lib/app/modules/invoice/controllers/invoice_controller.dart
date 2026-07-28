import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class InvoiceController extends GetxController {

  void backToHome() {
    // Pakai offAllNamed supaya tumpukan halaman sebelumnya (checkout, payment) dihapus
    // Pastikan Routes.HOME adalah halaman utama lu, atau ganti ke Routes.MAIN kalau lu pakai bottom navbar
    Get.offAllNamed(Routes.HOME);
  }

  void saveInvoice() {
    // Nanti di sini logic buat nyimpen widget jadi gambar (misal pakai screenshot package)
    Get.snackbar(
      'Berhasil',
      'Bukti transaksi berhasil disimpan ke galeri lu.',
      snackPosition: SnackPosition.TOP,
    );
  }
}