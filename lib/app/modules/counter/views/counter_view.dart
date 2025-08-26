import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/counter_controller.dart';

class CounterView extends GetView<CounterController> {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // ilangin panah back default
        title: const Text('CounterView'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.offAllNamed('/home');
        },
        icon: const Icon(Icons.home),
        label: const Text("Home"),
      ),
      body: Center(
        child: Obx(() {
          // Font size dinamis
          double fontSize = 50 + (controller.count.value / 5);

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Counter: ${controller.count}',
                style: TextStyle(fontSize: fontSize),
              ),
              const SizedBox(height: 20),

              // Validasi minimal 1
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
                  ElevatedButton.icon(
                    onPressed: controller.decrement,
                    icon: const Icon(Icons.remove),
                    label: const Text('Kurang'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: controller.increment,
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah'),
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
