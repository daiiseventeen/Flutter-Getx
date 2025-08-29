import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx1/app/data/models/alquran.dart';
import 'package:getx1/app/modules/alquran/controllers/alquran_controller.dart';

class AlquranViewDetail extends StatelessWidget {
  final Alquran surah;
  final AlquranController controller = Get.find<AlquranController>();

  AlquranViewDetail({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    final isMekah = surah.type == Type.MEKAH;

    return Scaffold(
      appBar: AppBar(
        title: Text(surah.nama ?? "Detail Surah"),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Surah
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green.shade100,
                    child: Text(
                      surah.urut ?? "-",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          surah.nama ?? "-",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "(${surah.asma ?? ""})",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          isMekah ? Colors.orange.shade100 : Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isMekah ? "Mekah" : "Madinah",
                      style: TextStyle(
                        color: isMekah
                            ? Colors.orange.shade700
                            : Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Arti
            Text(
              "Arti: ${surah.arti ?? "-"}",
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 8),

            // Info tambahan
            Row(
              children: [
                Icon(Icons.format_list_numbered,
                    size: 18, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Text("${surah.ayat ?? 0} ayat"),
              ],
            ),

            const SizedBox(height: 8),

            if (surah.keterangan != null && surah.keterangan!.isNotEmpty)
              Text(
                surah.keterangan ?? "",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),

            const SizedBox(height: 24),

            // Tombol Audio & Bookmark
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: surah.audio != null
                      ? () => controller.playAudio(surah)
                      : null,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Putar Audio"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => controller.bookmarkSurah(surah),
                  icon: const Icon(Icons.bookmark),
                  label: const Text("Bookmark"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
