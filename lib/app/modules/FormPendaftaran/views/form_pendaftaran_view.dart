import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/form_pendaftaran_controller.dart';

class FormPendaftaranView extends GetView<FormPendaftaranController> {
  const FormPendaftaranView({super.key});

  @override
  Widget build(BuildContext context) {
    final FormPendaftaranController controller = Get.put(
      FormPendaftaranController(),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Form Pendaftaran'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Form Pendaftaran',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Form Nama
              Obx(
                () => TextFormField(
                  onChanged: (value) {
                    controller.name.value = value;
                    controller.nameError.value = '';
                  },
                  decoration: InputDecoration(
                    labelText: 'Nama Lengkap',
                    hintText: 'Masukkan nama lengkap Anda',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person),
                    errorText: controller.nameError.value.isEmpty
                        ? null
                        : controller.nameError.value,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Form Gender
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Jenis Kelamin',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Laki-laki'),
                            value: 'Laki-laki',
                            groupValue: controller.gender.value.isEmpty
                                ? null
                                : controller.gender.value,
                            onChanged: (value) {
                              controller.gender.value = value ?? '';
                              controller.genderError.value = '';
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Perempuan'),
                            value: 'Perempuan',
                            groupValue: controller.gender.value.isEmpty
                                ? null
                                : controller.gender.value,
                            onChanged: (value) {
                              controller.gender.value = value ?? '';
                              controller.genderError.value = '';
                            },
                          ),
                        ),
                      ],
                    ),
                    if (controller.genderError.value.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 12, top: 4),
                        child: Text(
                          controller.genderError.value,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Form Tanggal Lahir
              Obx(
                () => InkWell(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate:
                          controller.dateOfBirth.value ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      controller.dateOfBirth.value = pickedDate;
                      controller.dateOfBirthError.value = '';
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: controller.dateOfBirthError.value.isEmpty
                            ? Colors.grey
                            : Theme.of(context).colorScheme.error,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            controller.dateOfBirth.value == null
                                ? 'Pilih Tanggal Lahir'
                                : '${controller.dateOfBirth.value!.day}/${controller.dateOfBirth.value!.month}/${controller.dateOfBirth.value!.year}',
                            style: TextStyle(
                              fontSize: 16,
                              color: controller.dateOfBirth.value == null
                                  ? Colors.grey[600]
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),  
                  ),
                ),
              ),
              Obx(
                () => controller.dateOfBirthError.value.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(left: 12, top: 4),
                        child: Text(
                          controller.dateOfBirthError.value,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 16),

              // Form Nomor Telepon (hanya angka)
              Obx(
                () => TextFormField(
                  keyboardType: TextInputType.number, // hanya angka
                  onChanged: (value) {
                    controller.phone.value = value;
                    controller.phoneError.value = '';
                  },
                  decoration: InputDecoration(
                    labelText: 'Nomor Telepon',
                    hintText: 'Masukkan nomor telepon Anda',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.phone),
                    errorText: controller.phoneError.value.isEmpty
                        ? null
                        : controller.phoneError.value,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    controller.submitForm();
                  },
                  child: const Text('Simpan', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),

      // Floating button untuk balik ke Home
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.offAllNamed('/home');
        },
        icon: const Icon(Icons.home),
        label: const Text("Home"),
      ),
    );
  }

  void _validateAndSubmit(FormPendaftaranController controller) {
    bool isValid = true;
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$'); // hanya huruf + spasi

    // Validasi nama
    if (controller.name.value.isEmpty) {
      controller.nameError.value = 'Nama tidak boleh kosong';
      isValid = false;
    } else if (controller.name.value.length < 3) {
      controller.nameError.value = 'Nama minimal 3 huruf';
      isValid = false;
    } else if (!nameRegex.hasMatch(controller.name.value)) {
      controller.nameError.value = 'Nama hanya boleh huruf dan spasi';
      isValid = false;
    }

    // Validasi gender
    if (controller.gender.value.isEmpty) {
      controller.genderError.value = 'Jenis kelamin harus dipilih';
      isValid = false;
    }

    // Validasi tanggal lahir + umur
    if (controller.dateOfBirth.value == null) {
      controller.dateOfBirthError.value = 'Tanggal lahir harus dipilih';
      isValid = false;
    } else {
      final today = DateTime.now();
      int age = today.year - controller.dateOfBirth.value!.year;
      if (today.month < controller.dateOfBirth.value!.month ||
          (today.month == controller.dateOfBirth.value!.month &&
              today.day < controller.dateOfBirth.value!.day)) {
        age--;
      }

      if (age < 15) {
        controller.dateOfBirthError.value =
            'Umur tidak mencukupi (minimal 15 tahun)';
        isValid = false;
      }
    }

    // Validasi nomor telepon
    if (controller.phone.value.isEmpty) {
      controller.phoneError.value = 'Nomor telepon tidak boleh kosong';
      isValid = false;
    } else if (controller.phone.value.length < 10) {
      controller.phoneError.value = 'Nomor telepon minimal 10 digit';
      isValid = false;
    }
  }
}
