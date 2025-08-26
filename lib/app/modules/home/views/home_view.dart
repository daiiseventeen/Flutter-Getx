import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2, // jumlah kolom
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: [
            // Card Menu Counter
            _buildMenuCard(
              icon: Icons.exposure_plus_1,
              label: "Counter",
              color: Colors.blue,
              onTap: () => Get.toNamed('counter'),
            ),

            // Card Menu Form Pendaftaran
            _buildMenuCard(
              icon: Icons.app_registration,
              label: "Form Pendaftaran",
              color: Colors.green,
              onTap: () => Get.toNamed('form-pendaftaran'),
            ),
          ],
        ),
      ),
    );
  }

  // Widget reusable untuk menu
  Widget _buildMenuCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color,
              child: Icon(icon, size: 32, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
