// Lokasi: lib/app/modules/profile/controllers/profile_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  // Data Profil User
  var name = 'Dwi Tegar Nugraha Putra'.obs;
  var phone = '085602370853'.obs;
  var email = 'dwitegar2121@gmail.com'.obs;
  var gender = 'Laki-laki'.obs;
  var birthDate = DateTime(2002, 5, 20).obs;

  // State Path Foto Profil (Gaya PaymentConfirmationController)
  var profileImagePath = ''.obs;

  // Setting Bahasa & Progress
  var selectedLanguage = 'Bahasa Indonesia'.obs;
  var completionProgress = 5.obs;
  var totalSteps = 6;

  // Controllers untuk Form Edit Profil
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  // Instance ImagePicker
  final ImagePicker _picker = ImagePicker();

  // Dummy Log Activity
  final List<Map<String, String>> logActivities = [
    {
      'device': 'Lenovo ThinkPad X1 Carbon',
      'location': 'Purbalingga, Jawa Tengah',
      'time': 'Hari ini, 11:59 WIB',
      'status': 'Aktif Sekarang',
    },
    {
      'device': 'Samsung Galaxy A05s',
      'location': 'Purbalingga, Jawa Tengah',
      'time': 'Kemarin, 20:15 WIB',
      'status': 'Berhasil Login',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: name.value);
    phoneController = TextEditingController(text: phone.value);
    emailController = TextEditingController(text: email.value);
  }

  // ==========================================
  // FUNGSI PILIH FOTO DARI GALERI (Gaya Payment Confirmation)
  // ==========================================
  Future<void> pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // Kompres dikit biar enteng
      );

      if (image != null) {
        profileImagePath.value = image.path;
        Get.snackbar(
          'Foto Diperbarui',
          'Foto profil berhasil dipilih!',
          backgroundColor: const Color(0xFF007A4B),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil gambar: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  // Formatting Tanggal Lahir
  String get formattedBirthDate {
    try {
      return DateFormat('dd MMMM yyyy', 'id_ID').format(birthDate.value);
    } catch (e) {
      return DateFormat('dd MMMM yyyy').format(birthDate.value);
    }
  }

  // Pick Date Function
  Future<void> pickBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthDate.value,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF007A4B),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      birthDate.value = picked;
    }
  }

  // Action Simpan Edit Profil
  void saveProfile() {
    name.value = nameController.text;
    phone.value = phoneController.text;
    email.value = emailController.text;
    Get.back();
    Get.snackbar(
      'Berhasil',
      'Data profil kamu berhasil diperbarui!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF007A4B),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}