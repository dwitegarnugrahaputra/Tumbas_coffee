// Lokasi: lib/app/modules/auth/controllers/auth_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  late TextEditingController loginEmailController;
  late TextEditingController loginPasswordController;

  late TextEditingController registerNameController;
  late TextEditingController registerEmailController;
  late TextEditingController registerPasswordController;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loginEmailController = TextEditingController();
    loginPasswordController = TextEditingController();

    registerNameController = TextEditingController();
    registerEmailController = TextEditingController();
    registerPasswordController = TextEditingController();
  }

  // 1. LOGIC LOGIN SUPABASE
  Future<void> login() async {
    if (loginEmailController.text.trim().isEmpty || loginPasswordController.text.isEmpty) {
      Get.snackbar('Perhatian', 'Email dan password tidak boleh kosong!');
      return;
    }

    try {
      isLoading.value = true;

      final response = await supabase.auth.signInWithPassword(
        email: loginEmailController.text.trim(),
        password: loginPasswordController.text,
      );

      if (response.user != null) {
        await supabase.from('user_logs').insert({
          'user_id': response.user!.id,
          'action': 'LOGIN_SUCCESS',
        });

        // UBAH DI SINI: Arahkan ke Routes.MAIN (bukan Routes.HOME)
        Get.offAllNamed(Routes.MAIN);

        Get.snackbar(
          'Selamat Datang',
          'Berhasil masuk ke akun Tumbas Kopi!',
          backgroundColor: const Color(0xFF007A4B),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Gagal Login',
        'Email atau password salah. Coba periksa kembali!',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 2. LOGIC REGISTER SUPABASE
  Future<void> register() async {
    if (registerEmailController.text.trim().isEmpty ||
        registerPasswordController.text.isEmpty ||
        registerNameController.text.trim().isEmpty) {
      Get.snackbar('Perhatian', 'Semua kolom wajib diisi!');
      return;
    }

    try {
      isLoading.value = true;

      final response = await supabase.auth.signUp(
        email: registerEmailController.text.trim(),
        password: registerPasswordController.text,
        data: {
          'full_name': registerNameController.text.trim(),
        },
      );

      if (response.user != null) {
        await supabase.from('user_logs').insert({
          'user_id': response.user!.id,
          'action': 'REGISTER_SUCCESS',
        });

        // UBAH DI SINI JUGA: Arahkan ke Routes.MAIN
        Get.offAllNamed(Routes.MAIN);

        Get.snackbar(
          'Akun Terbuat',
          'Registrasi berhasil! Selamat bergabung di Tumbas Kopi.',
          backgroundColor: const Color(0xFF007A4B),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Gagal Pendaftaran',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();

    registerNameController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    super.onClose();
  }
}