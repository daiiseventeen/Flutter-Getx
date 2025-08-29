
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getx1/app/modules/auth/controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  final ProfileController controller = Get.put(ProfileController());
  final AuthController authController = Get.put(AuthController());

  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: RefreshIndicator(
        onRefresh: () => controller.refreshProfile(),
        child: Obx(() {
          if (controller.isLoading.value && controller.userProfile.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.userProfile.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off_outlined, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 20),
                  Text('Gagal memuat profil', style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey.shade600)),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () => controller.fetchProfile(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            );
          }

          final user = controller.userProfile.value;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 240.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.blue.shade800,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    user['name']?.toString() ?? 'Nama Tidak Tersedia',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade800, Colors.lightBlue.shade400],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person, size: 60, color: Colors.blue), // Placeholder for profile image
                            ),
                            const SizedBox(height: 10),
                            Text(
                              user['email']?.toString() ?? 'Email Tidak Tersedia',
                              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Informasi Akun'),
                      const SizedBox(height: 10),
                      _buildInfoCard(user),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Pengaturan'),
                      const SizedBox(height: 10),
                      _buildSettingsList(),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () => authController.logout(),
                          icon: const Icon(Icons.logout, color: Colors.redAccent),
                          label: Text(
                            'Keluar',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.redAccent),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.1),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _buildInfoCard(Map<String, dynamic> user) {
    return Card(
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow(Icons.person_outline, 'Nama Lengkap', user['name']?.toString() ?? '-'),
            const Divider(height: 24),
            _buildInfoRow(Icons.email_outlined, 'Email', user['email']?.toString() ?? '-'),
            const Divider(height: 24),
            _buildInfoRow(Icons.calendar_today_outlined, 'Bergabung Sejak', user['created_at']?.toString() ?? '-'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 22, color: Colors.blue.shade700),
        const SizedBox(width: 16),
        Text(label, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500)),
        const Spacer(),
        Flexible(child: Text(value, style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey.shade700), textAlign: TextAlign.end)),
      ],
    );
  }

  Widget _buildSettingsList() {
    return Card(
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          _buildSettingsItem(Icons.edit_outlined, 'Edit Profil', () {}),
          _buildSettingsItem(Icons.notifications_outlined, 'Notifikasi', () {}),
          _buildSettingsItem(Icons.lock_outline, 'Ubah Kata Sandi', () {}),
          _buildSettingsItem(Icons.help_outline, 'Bantuan', () {}, showDivider: false),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, VoidCallback onTap, {bool showDivider = true}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: Colors.blue.shade700, size: 24),
                const SizedBox(width: 16),
                Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
          ),
          if (showDivider) const Divider(height: 1, indent: 56),
        ],
      ),
    );
  }
}
