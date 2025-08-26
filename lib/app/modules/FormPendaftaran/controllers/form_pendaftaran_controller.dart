import 'dart:ui';

import 'package:get/get.dart';

class FormPendaftaranController extends GetxController {
  // Data fields
  RxString name = ''.obs;
  RxString gender = ''.obs;
  Rxn<DateTime> dateOfBirth = Rxn<DateTime>();
  RxString phone = ''.obs;

  // Validation error fields
  RxString nameError = ''.obs;
  RxString genderError = ''.obs;
  RxString dateOfBirthError = ''.obs;
  RxString phoneError = ''.obs;

  final count = 0.obs;

  void increment() => count.value++;

  // Method untuk clear semua form
  void clearForm() {
    name.value = '';
    gender.value = '';
    dateOfBirth.value = null;
    phone.value = '';
    clearErrors();
  }

  // Method untuk clear semua error
  void clearErrors() {
    nameError.value = '';
    genderError.value = '';
    dateOfBirthError.value = '';
    phoneError.value = '';
  }

  // Method untuk validasi semua field
  bool validateAll() {
    clearErrors();
    bool isValid = true;

    if (name.value.isEmpty) {
      nameError.value = 'Nama tidak boleh kosong';
      isValid = false;
    }

    if (gender.value.isEmpty) {
      genderError.value = 'Jenis kelamin harus dipilih';
      isValid = false;
    }

    if (dateOfBirth.value == null) {
      dateOfBirthError.value = 'Tanggal lahir harus dipilih';
      isValid = false;
    }

    if (phone.value.isEmpty) {
      phoneError.value = 'Nomor telepon tidak boleh kosong';
      isValid = false;
    } else if (phone.value.length < 10) {
      phoneError.value = 'Nomor telepon minimal 10 digit';
      isValid = false;
    } else if (!RegExp(r'^[0-9]+$').hasMatch(phone.value)) {
      phoneError.value = 'Nomor telepon hanya boleh berisi angka';
      isValid = false;
    }

    return isValid;
  }

  // Method untuk submit form
  void submitForm() {
    if (validateAll()) {
      // Navigasi ke halaman results dengan membawa data
      Get.toNamed(
        '/results',
        arguments: {
          'name': name.value,
          'gender': gender.value,
          'dob': _formatDate(dateOfBirth.value!),
          'phone': phone.value,
        },
      );
    } else {
      Get.snackbar(
        'Error',
        'Mohon lengkapi semua field yang wajib diisi',
        backgroundColor: const Color(0xFFF44336),
        colorText: const Color(0xFFFFFFFF),
      );
    }
  }

  // Helper method untuk format tanggal
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Method untuk mendapatkan umur dari tanggal lahir
  int? getAge() {
    if (dateOfBirth.value == null) return null;
    DateTime now = DateTime.now();
    int age = now.year - dateOfBirth.value!.year;
    if (now.month < dateOfBirth.value!.month ||
        (now.month == dateOfBirth.value!.month &&
            now.day < dateOfBirth.value!.day)) {
      age--;
    }
    return age;
  }
}
