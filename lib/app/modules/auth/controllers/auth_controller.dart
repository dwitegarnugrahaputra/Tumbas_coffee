import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  // Controller untuk form Login
  final emailLoginCtrl = TextEditingController();
  final passwordLoginCtrl = TextEditingController();

  // Controller untuk form Register
  final nameRegCtrl = TextEditingController();
  final emailRegCtrl = TextEditingController();
  final phoneRegCtrl = TextEditingController();
  final passwordRegCtrl = TextEditingController();
  final confirmPassRegCtrl = TextEditingController();

  // State untuk show/hide password
  var isLoginPasswordHidden = true.obs;
  var isRegPasswordHidden = true.obs;
  var isRegConfirmPasswordHidden = true.obs;

  @override
  void onClose() {
    emailLoginCtrl.dispose();
    passwordLoginCtrl.dispose();
    nameRegCtrl.dispose();
    emailRegCtrl.dispose();
    phoneRegCtrl.dispose();
    passwordRegCtrl.dispose();
    confirmPassRegCtrl.dispose();
    super.onClose();
  }

  // Fungsi dummy untuk tombol (Nanti kita sambungin ke Supabase)
  void login() {
    Get.offAllNamed(Routes.MAIN);
  }

  void register() {
    print("Daftar dengan: ${nameRegCtrl.text}");
    // TODO: Hit API Supabase Register
  }
}