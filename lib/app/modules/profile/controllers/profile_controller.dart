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

  // Progress Kalkulasi Dinamis (6 Total Item Profil)
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

  // FUNGSI UNTUK MENGHITUNG PROGRES KELENGKAPAN PROFIL (DINAMIS)
  void updateProfileProgress() {
    int count = 0;

    if (name.value.isNotEmpty && name.value != 'Pelanggan Tumbas') count++;
    if (phone.value.isNotEmpty && phone.value != '-') count++;
    if (email.value.isNotEmpty && email.value != '-') count++;
    if (gender.value.isNotEmpty) count++;
    // birthDate.value tidak pernah null karena bertipe DateTime, jadi langsung count++
    count++;
    if (profileImagePath.value.isNotEmpty) count++;

    completionProgress.value = count;
  }

  // 1. TARIK DATA PROFIL DARI TABEL PROFILES
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

        // Ambil tanggal lahir jika string dari Supabase ada
        if (data['birth_date'] != null && data['birth_date'].toString().isNotEmpty) {
          birthDate.value = DateTime.parse(data['birth_date']);
        }

        if (data['avatar_url'] != null) {
          profileImagePath.value = data['avatar_url'];
        }

        // Sync ke Text Controller
        nameController.text = name.value;
        phoneController.text = phone.value;
        emailController.text = email.value;

        // Hitung progres kelengkapan
        updateProfileProgress();
      }
    } catch (e) {
      Get.snackbar('Error Profil', 'Gagal memuat profil: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // 2. TARIK RIWAYAT LOG AKTIVITAS
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

      logActivities.value = response.map((log) {
        final date = DateTime.parse(log['created_at']).toLocal();
        final formattedTime = DateFormat('dd MMM yyyy, HH:mm').format(date);
        return {
          'device': 'Peranti Mobile',
          'location': 'Purbalingga, Jawa Tengah',
          'time': '$formattedTime WIB',
          'status': log['action'] == 'LOGIN_SUCCESS' ? 'Aktif / Login' : log['action'].toString(),
        };
      }).toList();
    } catch (e) {
      // Fallback
    }
  }

  // 3. SIMPAN PERUBAHAN PROFIL KE DATABASE SUPABASE
  Future<void> saveProfile() async {
    try {
      isLoading.value = true;
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        Get.snackbar('Gagal', 'Sesi login tidak ditemukan.');
        return;
      }

      final birthDateFormatted = DateFormat('yyyy-MM-dd').format(birthDate.value);

      // Gunakan update() ke Supabase DB
      await supabase.from('profiles').update({
        'full_name': nameController.text,
        'phone_number': phoneController.text,
        'email': emailController.text,
        'gender': gender.value,
        'birth_date': birthDateFormatted,
        'avatar_url': profileImagePath.value,
      }).eq('id', userId);

      // Update State Lokal
      name.value = nameController.text;
      phone.value = phoneController.text;
      email.value = emailController.text;

      // Recalculate Progress
      updateProfileProgress();

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

  // 4. PILIH FOTO PROFIL DARI GALERI HP
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