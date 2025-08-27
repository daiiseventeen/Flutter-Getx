import 'package:get/get.dart';
import 'package:getx1/app/data/models/alquran.dart';
import 'package:getx1/app/services/alquran_service.dart';

class AlquranController extends GetxController {
  final AlquranServis _alquranService = Get.put(AlquranServis());

  RxList<Alquran> listSurah = <Alquran>[].obs;
  RxList<Alquran> filteredList = <Alquran>[].obs;

  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;
  RxString searchQuery = ''.obs;
  Rx<Type?> selectedType = Rx<Type?>(null);

  List<Alquran> get alquran => listSurah;

  // Statistik
  int get totalSurah => listSurah.length;
  int get mekahCount =>
      listSurah.where((s) => s.type == Type.MEKAH).length;
  int get madinahCount =>
      listSurah.where((s) => s.type == Type.MADINAH).length;

  List<Alquran> get filteredAlquranList => filteredList;

  @override
  void onInit() {
    super.onInit();
    fetchAlquran();
  }

  Future<void> fetchAlquran() async {
    try {
      isLoading(true);
      errorMessage('');

      final response = await _alquranService.fetchAlquran();

      if (response.statusCode == 200) {
        var data = (response.body as List)
            .map((surahJson) => Alquran.fromJson(surahJson))
            .toList();

        listSurah.assignAll(data);
        applyFilters();
      } else {
        errorMessage('Error: ${response.statusText}');
      }
    } catch (e) {
      errorMessage('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  void searchSurah(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void filterByType(Type? type) {
    selectedType.value = type;
    applyFilters();
  }

  void applyFilters() {
    var results = listSurah.toList();

    if (selectedType.value != null) {
      results =
          results.where((s) => s.type == selectedType.value).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      results = results
          .where((s) =>
              (s.nama ?? '').toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              (s.arti ?? '').toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    filteredList.assignAll(results);
  }

  Future<void> refreshData() async {
    await fetchAlquran();
  }

  void playAudio(Alquran surah) {
    if (surah.audio != null) {
      Get.snackbar("Play Audio", "Memutar audio untuk surah ${surah.nama}");
    } else {
      Get.snackbar("Audio tidak tersedia", "");
    }
  }

  void bookmarkSurah(Alquran surah) {
    Get.snackbar("Bookmark", "Surah ${surah.nama} ditandai");
  }
}
