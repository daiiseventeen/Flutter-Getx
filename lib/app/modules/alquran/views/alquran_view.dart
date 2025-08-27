import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx1/app/data/models/alquran.dart';
import 'package:getx1/app/modules/alquran/controllers/alquran_controller.dart';
import 'package:getx1/app/modules/alquran/views/alquran_view_detail.dart';

class AlquranView extends StatelessWidget {
  AlquranView({Key? key}) : super(key: key);

  final AlquranController controller = Get.put(AlquranController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Al-Quran',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => controller.refreshData(),
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔎 Search + Filter
          _buildSearchAndFilter(),
          // 📖 Content
          Expanded(child: Obx(() => _buildContent())),
        ],
      ),

      // 🏠 Tombol Home
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.offAllNamed('/home');
        },
        icon: const Icon(Icons.home),
        label: const Text("Home"),
      ),
    );
  }

  /// 🔎 Bagian Search & Filter
  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade700,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Search Field
          TextField(
            controller: searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Cari surah...',
              hintStyle: const TextStyle(color: Colors.white70),
              prefixIcon: const Icon(Icons.search, color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              suffixIcon: Obx(() => controller.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white70),
                      onPressed: () {
                        searchController.clear();
                        controller.searchSurah('');
                      },
                    )
                  : const SizedBox()),
            ),
            onChanged: (value) => controller.searchSurah(value),
          ),
          const SizedBox(height: 12),

          // Filter Buttons
          Row(
            children: [
              _buildFilterButton('Semua', () => controller.filterByType(null)),
              const SizedBox(width: 8),
              _buildFilterButton(
                  'Mekah', () => controller.filterByType(Type.MEKAH)),
              const SizedBox(width: 8),
              _buildFilterButton(
                  'Madinah', () => controller.filterByType(Type.MADINAH)),
            ],
          ),

          // Stats
          const SizedBox(height: 12),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard('Total', '${controller.totalSurah}', Icons.book),
                  _buildStatCard('Mekah', '${controller.mekahCount}', Icons.location_on),
                  _buildStatCard('Madinah', '${controller.madinahCount}', Icons.mosque),
                ],
              )),
        ],
      ),
    );
  }

  /// 📖 Konten utama
  Widget _buildContent() {
    if (controller.isLoading.value) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.green),
            SizedBox(height: 16),
            Text('Memuat data Al-Quran...'),
          ],
        ),
      );
    }

    if (controller.errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error: ${controller.errorMessage.value}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.refreshData(),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (controller.filteredAlquranList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Tidak ada surah ditemukan',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => controller.refreshData(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.filteredAlquranList.length,
        itemBuilder: (context, index) {
          final surah = controller.filteredAlquranList[index];
          return _buildSurahCard(surah);
        },
      ),
    );
  }

  /// 📊 Kartu Statistik
  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          Text(title,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  /// 📌 Tombol Filter
  Widget _buildFilterButton(String label, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.2),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  /// 📖 Kartu Surah
  Widget _buildSurahCard(Alquran surah) {
    final isMekah = surah.type == Type.MEKAH;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Get.to(() => AlquranViewDetail(surah: surah));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Nomor Surah
              CircleAvatar(
                backgroundColor: Colors.green.shade100,
                child: Text(
                  surah.urut ?? '0',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Surah Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            surah.nama ?? '',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isMekah
                                ? Colors.orange.shade100
                                : Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isMekah ? 'Mekah' : 'Madinah',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isMekah
                                  ? Colors.orange.shade700
                                  : Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      surah.arti ?? '',
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.format_list_numbered,
                            size: 16, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          '${surah.ayat ?? 0} Ayat',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade500),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.place,
                            size: 16,
                            color: isMekah
                                ? Colors.orange.shade500
                                : Colors.blue.shade500),
                        const SizedBox(width: 4),
                        Text(
                          isMekah ? 'Mekah' : 'Madinah',
                          style: TextStyle(
                              fontSize: 12,
                              color: isMekah
                                  ? Colors.orange.shade500
                                  : Colors.blue.shade500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action Buttons
              Column(
                children: [
                  IconButton(
                    onPressed: surah.audio != null
                        ? () => controller.playAudio(surah)
                        : null,
                    icon: Icon(Icons.play_circle,
                        color: surah.audio != null
                            ? Colors.green.shade600
                            : Colors.grey),
                    iconSize: 28,
                  ),
                  IconButton(
                    onPressed: () => controller.bookmarkSurah(surah),
                    icon: Icon(Icons.bookmark_border,
                        color: Colors.amber.shade600),
                    iconSize: 24,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
