// Lokasi: lib/app/modules/profile/views/profile_view.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../../main.dart'; // Import client 'supabase'
import '../../../routes/app_pages.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Note: Inisialisasi controller dikelola oleh Bindings (ProfileBinding / MainBinding)

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ==========================================
            // 1. HEADER HIJAU & FLOATING CARD LENGKAPI PROFIL
            // ==========================================
            Stack(
              children: [
                // Container Background Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 80),
                  decoration: const BoxDecoration(
                    color: Color(0xFF007A4B),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Akun Saya',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          // Avatar Circle Header Utama
                          Obx(() {
                            final hasLocalImage = controller.profileImagePath.value.isNotEmpty;
                            return CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.white24,
                              backgroundImage: hasLocalImage
                                  ? FileImage(File(controller.profileImagePath.value))
                                  : null,
                              child: !hasLocalImage
                                  ? const Icon(Icons.person, size: 36, color: Colors.white)
                                  : null,
                            );
                          }),
                          const SizedBox(width: 16),

                          // Ringkasan Info User Header
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() => Text(
                                  controller.name.value,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                                const SizedBox(height: 4),
                                Obx(() => Text(
                                  controller.phone.value,
                                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                                )),
                                Obx(() => Text(
                                  controller.email.value,
                                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Floating Card "Lengkapi Profil Kamu" (Sembunyi otomatis jika 6/6)
                Obx(() {
                  if (controller.completionProgress.value >= controller.totalSteps) {
                    return const SizedBox.shrink();
                  }

                  return Container(
                    margin: const EdgeInsets.fromLTRB(20, 170, 20, 0),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FCF9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Lengkapi profil kamu',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: () => _showEditProfileSheet(context),
                              child: Row(
                                children: [
                                  Text(
                                    '${controller.completionProgress.value}/${controller.totalSteps}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Color(0xFF007A4B),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.chevron_right, size: 18, color: Color(0xFF007A4B)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: controller.completionProgress.value / controller.totalSteps,
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF007A4B)),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Tambahkan Jenis Kelamin & Foto Profil di pengaturan profil.',
                          style: TextStyle(fontSize: 11, color: Colors.black87),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),

            const SizedBox(height: 24),

            // ==========================================
            // 2. PENGATURAN AKUN (MENU LIST)
            // ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pengaturan Akun', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),

                  _buildSettingTile(
                    title: 'Ubah Profil',
                    subtitle: 'Data diri, foto, email, dan tanggal lahir',
                    icon: Icons.person_outline,
                    onTap: () => _showEditProfileSheet(context),
                  ),
                  const Divider(height: 1),

                  Obx(() => _buildSettingTile(
                    title: 'Bahasa / Language',
                    subtitle: controller.selectedLanguage.value,
                    icon: Icons.language,
                    onTap: () => _showLanguageDialog(context),
                  )),
                  const Divider(height: 1),

                  _buildSettingTile(
                    title: 'Log Activity',
                    subtitle: 'Lihat riwayat sesi dan perangkat akunmu',
                    icon: Icons.history,
                    onTap: () => _showLogActivitySheet(context),
                  ),
                  const Divider(height: 1),

                  const SizedBox(height: 24),

                  // Tombol Keluar dari Akun
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red[100]!),
                    ),
                    child: TextButton.icon(
                      onPressed: () => _showLogoutDialog(context),
                      icon: const Icon(Icons.logout, color: Colors.red, size: 20),
                      label: const Text(
                        'Keluar dari Akun',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Text(
              'Tumbas Kopi v2.4.0',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(icon, color: Colors.black87, size: 22),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
    );
  }

  // BottomSheet Ubah Profil
  void _showEditProfileSheet(BuildContext context) {
    controller.nameController.text = controller.name.value;
    controller.phoneController.text = controller.phone.value;
    controller.emailController.text = controller.email.value;

    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Ubah Profil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Get.back()),
                ],
              ),
              const SizedBox(height: 12),

              // Pick Foto Profil
              Center(
                child: Stack(
                  children: [
                    Obx(() {
                      final hasImage = controller.profileImagePath.value.isNotEmpty;
                      return CircleAvatar(
                        radius: 42,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: hasImage
                            ? FileImage(File(controller.profileImagePath.value))
                            : null,
                        child: !hasImage
                            ? const Icon(Icons.person, size: 50, color: Colors.grey)
                            : null,
                      );
                    }),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: controller.pickProfileImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF007A4B),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text('Nama Lengkap', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 6),
              TextField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),

              const Text('Nomor Handphone', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 6),
              TextField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),

              const Text('Email', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 6),
              TextField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),

              const Text('Jenis Kelamin', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 8),
              Obx(() => Row(
                children: [
                  Expanded(
                    child: _buildGenderChip('Laki-laki', controller.gender.value == 'Laki-laki'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildGenderChip('Perempuan', controller.gender.value == 'Perempuan'),
                  ),
                ],
              )),
              const SizedBox(height: 16),

              const Text('Tanggal Lahir', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => controller.pickBirthDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(
                        controller.formattedBirthDate,
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      )),
                      const Icon(Icons.calendar_today, size: 18, color: Color(0xFF007A4B)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007A4B),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                      : const Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                )),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildGenderChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.gender.value = label,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE2F0D9) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF007A4B) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xFF007A4B) : Colors.black87,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Pilih Bahasa / Select Language', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Bahasa Indonesia'),
              trailing: controller.selectedLanguage.value == 'Bahasa Indonesia'
                  ? const Icon(Icons.check_circle, color: Color(0xFF007A4B))
                  : null,
              onTap: () {
                controller.selectedLanguage.value = 'Bahasa Indonesia';
                Get.back();
              },
            ),
            const Divider(height: 1),
            ListTile(
              title: const Text('English'),
              trailing: controller.selectedLanguage.value == 'English'
                  ? const Icon(Icons.check_circle, color: Color(0xFF007A4B))
                  : null,
              onTap: () {
                controller.selectedLanguage.value = 'English';
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar Akun', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah kamu yakin ingin keluar dari aplikasi Tumbas Kopi?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();

              // 1. Catat log sebelum sesi beneran dihapus
              await controller.insertLogActivity('LOGOUT');

              // 2. Terminate Supabase Auth Session
              await supabase.auth.signOut();

              // 3. Clear & Redirection to Auth/Login Page
              Get.offAllNamed(Routes.LOGIN);

              Get.snackbar(
                'Berhasil Keluar',
                'Kamu telah keluar dari akun Tumbas Kopi',
                snackPosition: SnackPosition.TOP,
                backgroundColor: const Color(0xFF007A4B),
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
                borderRadius: 12,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Keluar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showLogActivitySheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Log Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Get.back()),
              ],
            ),
            const SizedBox(height: 16),
            Flexible(
              child: Obx(() {
                if (controller.logActivities.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: Text('Belum ada log aktivitas tercatat.', style: TextStyle(color: Colors.grey))),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.logActivities.length,
                  separatorBuilder: (context, index) => const Divider(height: 16),
                  itemBuilder: (context, index) {
                    final log = controller.logActivities[index];
                    final isCurrent = log['status'] == 'Aktif / Login';

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isCurrent ? const Color(0xFFE2F0D9) : Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.devices, color: isCurrent ? const Color(0xFF007A4B) : Colors.grey, size: 20),
                      ),
                      title: Text(log['device'] ?? 'Mobile Device', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: Text('${log['location']} • ${log['time']}', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isCurrent ? const Color(0xFF007A4B) : Colors.grey[200],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          log['status'] ?? 'Aktif',
                          style: TextStyle(
                            color: isCurrent ? Colors.white : Colors.grey[700],
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}