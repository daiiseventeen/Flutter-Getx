import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormPendaftaranController extends GetxController {
  // Stepper state
  var currentStep = 0.obs;

  // Text Editing Controllers
  late TextEditingController nameController;
  late TextEditingController phoneController;

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

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    phoneController = TextEditingController();

    // Listeners to sync text controllers with Rx variables
    nameController.addListener(() => name.value = nameController.text);
    phoneController.addListener(() => phone.value = phoneController.text);
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  // Method to clear all form data
  void clearForm() {
    nameController.clear();
    phoneController.clear();
    gender.value = '';
    dateOfBirth.value = null;
    clearErrors();
    currentStep.value = 0;
  }

  // Method to clear all error messages
  void clearErrors() {
    nameError.value = '';
    genderError.value = '';
    dateOfBirthError.value = '';
    phoneError.value = '';
  }

  // --- Step Validation ---

  bool validateStep1() {
    clearErrors();
    bool isValid = true;
    if (name.value.isEmpty) {
      nameError.value = 'Nama tidak boleh kosong';
      isValid = false;
    } else if (name.value.length < 3) {
      nameError.value = 'Nama minimal 3 karakter';
      isValid = false;
    }

    if (gender.value.isEmpty) {
      genderError.value = 'Jenis kelamin harus dipilih';
      isValid = false;
    }

    if (isValid) {
      currentStep.value++;
    }
    return isValid;
  }

  bool validateStep2() {
    bool isValid = true;
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

  // Method to submit the form
  void submitForm() {
    if (validateStep1() && validateStep2()) {
      Get.toNamed(
        '/results',
        arguments: {
          'name': name.value,
          'gender': gender.value,
          'dob': _formatDate(dateOfBirth.value!),
          'phone': phone.value,
        },
      );
    } else if (nameError.value.isEmpty && genderError.value.isEmpty) {
      // if step 1 is valid, but step 2 is not, we still need to check step 2
      validateStep2();
      Get.snackbar(
        'Error',
        'Mohon periksa kembali isian Anda di langkah ini.',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
       Get.snackbar(
        'Error',
        'Mohon lengkapi semua field yang wajib diisi dari awal.',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

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