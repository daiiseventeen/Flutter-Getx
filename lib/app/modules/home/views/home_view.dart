import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx1/app/modules/alquran/views/alquran_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menu = [
      {
        "title": "Al-Qur'an",
        "icon": Icons.menu_book, // 🔥 diganti jadi ikon buku
        "route": () => AlquranView(),
      },
      {
        "title": "Profil",
        "icon": Icons.person,
        "route": () => const Placeholder(), // nanti ganti ke halaman profil
      },
      {
        "title": "Pengaturan",
        "icon": Icons.settings,
        "route": () => const Placeholder(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: menu.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 kolom
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final item = menu[index];
          return TweenAnimationBuilder(
            duration: const Duration(milliseconds: 600),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: GestureDetector(
                  onTap: () {
                    Get.to(item["route"]);
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item["icon"],
                          size: 48,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item["title"],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
