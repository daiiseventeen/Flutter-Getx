import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/counter_controller.dart';

class CounterView extends GetView<CounterController> {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CounterView'),
        centerTitle: true,
      ),
      body: Center(
        child: Obx(() {
          // Font size menyesuaikan dengan nilai (default 20 + nilai/5)
          double fontSize = 50 + (controller.count.value / 5);

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Counter: ${controller.count}',
                style: TextStyle(fontSize: fontSize),
              ),
              const SizedBox(height: 20),

              // Kalau nilai < 1 → muncul notif + tombol kurang/tambah
              if (controller.count.value < 1) ...[
                const Text(
                  "Nilai terlalu kecil! (minimal 1)",
                  style: TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 10),
              ],

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: controller.decrement,
                    child: const Text('Kurang'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: controller.increment,
                    child: const Text('Tambah'),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
