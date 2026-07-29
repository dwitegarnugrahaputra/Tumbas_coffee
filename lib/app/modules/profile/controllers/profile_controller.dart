// Lokasi: lib/app/modules/profile/controllers/profile_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../main.dart'; // Shortcut client 'supabase'

class ProfileController extends GetxController {
  // Data Profil Reactive
  var name = 'Pelanggan Tumbas'.obs;
  var phone = '-'.obs;
  var email = '-'.obs;
  var gender = 'Laki-laki'.obs;
  var birthDate = DateTime(2000, 1, 1).obs;
  var profileImagePath = ''.obs;

  // Variabel Bahasa & State UI
  var selectedLanguage = 'Bahasa Indonesia'.obs;
  var isLoading = false.obs;

  // Progress Kalkulasi Dinamis
  var completionProgress = 0.obs;
  final int totalSteps = 6;

  // Real-time Audit Logs dari Supabase
  var logActivities = <Map<String, String>>[].obs;

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();

    fetchUserProfile();
    fetchUserLogs();
  }

  void updateProfileProgress() {
    int count = 0;
    if (name.value.isNotEmpty && name.value != 'Pelanggan Tumbas') count++;
    if (phone.value.isNotEmpty && phone.value != '-') count++;
    if (email.value.isNotEmpty && email.value != '-') count++;
    if (gender.value.isNotEmpty) count++;
    count++; // birthDate
    if (profileImagePath.value.isNotEmpty) count++;

    completionProgress.value = count;
  }

  // --- FUNGSI BARU: INSERT LOG AKTIVITAS ---
  Future<void> insertLogActivity(String actionName) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      await supabase.from('user_logs').insert({
        'user_id': userId,
        'action': actionName,
        // device_info & location_info pakai default dari DB dulu untuk sekarang
      });

      // Refresh list log setelah insert
      fetchUserLogs();
    } catch (e) {
      debugPrint('Gagal mencatat log: $e');
    }
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) return;

      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (data != null) {
        name.value = data['full_name'] ?? 'Pelanggan Tumbas';
        phone.value = data['phone_number'] ?? '-';
        email.value = data['email'] ?? (supabase.auth.currentUser?.email ?? '-');
        gender.value = data['gender'] ?? 'Laki-laki';

        if (data['birth_date'] != null && data['birth_date'].toString().isNotEmpty) {
          birthDate.value = DateTime.parse(data['birth_date']);
        }

        if (data['avatar_url'] != null) {
          profileImagePath.value = data['avatar_url'];
        }

        nameController.text = name.value;
        phoneController.text = phone.value;
        emailController.text = email.value;

        updateProfileProgress();
      }
    } catch (e) {
      Get.snackbar('Error Profil', 'Gagal memuat profil: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserLogs() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      final List<dynamic> response = await supabase
          .from('user_logs')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(5);

      // Tambahkan <Map<String, String>> pada map() dan pastikan nilainya di-.toString()
      logActivities.value = response.map<Map<String, String>>((log) {
        final date = DateTime.parse(log['created_at'].toString()).toLocal();
        final formattedTime = DateFormat('dd MMM yyyy, HH:mm').format(date);

        String statusLabel = log['action'].toString();
        if (statusLabel == 'LOGIN_SUCCESS') statusLabel = 'Aktif / Login';
        if (statusLabel == 'UPDATE_PROFILE') statusLabel = 'Ubah Profil';
        if (statusLabel == 'LOGOUT') statusLabel = 'Keluar Akun';

        return {
          'device': log['device_info']?.toString() ?? 'Peranti Mobile',
          'location': log['location_info']?.toString() ?? 'Tidak diketahui',
          'time': '$formattedTime WIB',
          'status': statusLabel,
        };
      }).toList();
    } catch (e) {
      debugPrint('Gagal fetch logs: $e');
    }
  }

  Future<void> saveProfile() async {
    try {
      isLoading.value = true;
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        Get.snackbar('Gagal', 'Sesi login tidak ditemukan.');
        return;
      }

      final birthDateFormatted = DateFormat('yyyy-MM-dd').format(birthDate.value);

      await supabase.from('profiles').update({
        'full_name': nameController.text,
        'phone_number': phoneController.text,
        'email': emailController.text,
        'gender': gender.value,
        'birth_date': birthDateFormatted,
        'avatar_url': profileImagePath.value,
      }).eq('id', userId);

      name.value = nameController.text;
      phone.value = phoneController.text;
      email.value = emailController.text;

      updateProfileProgress();

      // CATAT LOG AKTIVITAS SETELAH SUKSES UPDATE
      await insertLogActivity('UPDATE_PROFILE');

      Get.back();
      Get.snackbar(
        'Berhasil',
        'Data profil kamu berhasil disimpan!',
        backgroundColor: const Color(0xFF007A4B),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Gagal Update', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        profileImagePath.value = image.path;
        updateProfileProgress();
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memilih gambar: $e');
    }
  }

  String get formattedBirthDate {
    try {
      return DateFormat('dd MMMM yyyy', 'id_ID').format(birthDate.value);
    } catch (e) {
      return DateFormat('dd MMMM yyyy').format(birthDate.value);
    }
  }

  Future<void> pickBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthDate.value,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      birthDate.value = picked;
      updateProfileProgress();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}