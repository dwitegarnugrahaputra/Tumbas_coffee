import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {

  void goToEditProfile() {
    // Get.toNamed(Routes.EDIT_PROFILE);
    print("Ke halaman Edit Profil");
  }

  void goToLogActivity() {
    Get.toNamed(Routes.LOG_ACTIVITY);
  }

  void goToHelp() {
    // Get.toNamed(Routes.HELP);
    print("Ke halaman Bantuan");
  }

  void logout() {
    // Logika hapus token/session di sini
    Get.offAllNamed(Routes.LOGIN);
    Get.snackbar(
      'Berhasil',
      'Lu udah keluar dari akun.',
      snackPosition: SnackPosition.TOP,
    );
  }
}