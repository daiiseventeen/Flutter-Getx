import 'package:get/get.dart';

import '../controllers/form_pendaftaran_controller.dart';

class FormPendaftaranBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FormPendaftaranController>(
      () => FormPendaftaranController(),
    );
  }
}
