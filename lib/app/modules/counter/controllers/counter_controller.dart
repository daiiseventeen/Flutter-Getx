import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CounterController extends GetxController {
  RxInt count = 1.obs;

   void increment() {
    if (count < 100) {
      count++;
      if (count == 100) {
        Get.snackbar(
          "Danger",
          "Angka telah mencapai maksimum 100",
          icon: const Icon(Icons.warning, color: Colors.white),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      // sudah 100, jangan naik lagi
      Get.snackbar(
        "Info",
        "Nilai tidak bisa lebih dari 100",
        icon: const Icon(Icons.info, color: Colors.white),
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void decrement() {
    count--;
    if (count < 1) {
      count.value = 0; // biar ga negatif
      Get.snackbar(
        "Peringatan", 
        "Nilai tidak boleh kurang dari 1",
        icon: const Icon(Icons.error, color: Colors.white),
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
