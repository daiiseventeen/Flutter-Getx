import 'package:get/get.dart';

import '../modules/FormPendaftaran/bindings/form_pendaftaran_binding.dart';
import '../modules/FormPendaftaran/views/form_pendaftaran_view.dart';
import '../modules/FormPendaftaran/views/results_screen_view.dart';
import '../modules/alquran/bindings/alquran_binding.dart';
import '../modules/alquran/views/alquran_view.dart';
import '../modules/counter/bindings/counter_binding.dart';
import '../modules/counter/views/counter_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/post/bindings/post_binding.dart';
import '../modules/post/views/post_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.COUNTER,
      page: () => const CounterView(),
      binding: CounterBinding(),
    ),
    GetPage(
      name: _Paths.FORM_PENDAFTARAN,
      page: () => const FormPendaftaranView(),
      binding: FormPendaftaranBinding(),
    ),
    GetPage(
      name: _Paths.RESULTS,
      page: () => const ResultsScreenView(),
    ),
    GetPage(
      name: _Paths.POST,
      page: () => PostView(),
      binding: PostBinding(),
    ),
    GetPage(
      name: _Paths.ALQURAN,
      page: () => AlquranView(),
      binding: AlquranBinding(),
    ),
  ];
}
