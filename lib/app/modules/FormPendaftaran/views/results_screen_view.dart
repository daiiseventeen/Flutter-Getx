import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResultsScreenView extends StatelessWidget {
  const ResultsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil data dari argument
    final arguments = Get.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Pendaftaran"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Data Pendaftaran",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(height: 30, thickness: 1),
                Text("👤 Nama: ${arguments['name']}",
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text("⚧ Jenis Kelamin: ${arguments['gender']}",
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text("🎂 Tanggal Lahir: ${arguments['dob']}",
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text("📞 Telepon: ${arguments['phone']}",
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ),
      ),

      // Tombol floating balik ke Home
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.offAllNamed('/home');
        },
        icon: const Icon(Icons.home),
        label: const Text("Home"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
